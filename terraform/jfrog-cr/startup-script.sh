#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# Redirect all stdout/stderr to /var/log/startup-script.log
exec > /var/log/startup-script.log 2>&1

#######################
#     VARIABLES      #
#######################
DISK="/dev/sdb"
MOUNT_POINT="/opt/jfrog"
JFROG_HOME="$MOUNT_POINT"
DOMAIN="jfrog.nuwm-diploma.pp.ua"
EMAIL="yaremchyk2023r@gmail.com"

############################
# 1) WAIT FOR /dev/sdb     #
############################
echo "==> Waiting up to 30s for $DISK to appear..."
for i in {1..10}; do
  if [ -b "$DISK" ]; then
    echo "    $DISK is present."
    break
  fi
  echo "    $DISK not found yet; retrying in 3s..."
  sleep 3
done

if [ ! -b "$DISK" ]; then
  echo "ERROR: $DISK never appeared. Exiting disk setup."
  exit 1
fi

############################
# 2) DISK FORMATTING & MOUNT
############################
echo "==> Setting up and mounting $DISK to $MOUNT_POINT"
mkdir -p "$MOUNT_POINT"

# Check existing FS type
FS_TYPE=$(blkid -o value -s TYPE "$DISK" || true)
if [ -z "$FS_TYPE" ]; then
  echo "    No filesystem detected on $DISK; formatting as ext4..."
  mkfs.ext4 "$DISK"
elif [ "$FS_TYPE" != "ext4" ]; then
  echo "    $DISK has filesystem '$FS_TYPE'; reformatting to ext4..."
  mkfs.ext4 "$DISK"
else
  echo "    $DISK is already ext4; skipping mkfs."
fi

# Grab UUID and add/update in /etc/fstab
UUID=$(blkid -s UUID -o value "$DISK")
FSTAB_ENTRY="UUID=$UUID    $MOUNT_POINT    ext4    defaults    0    0"

if grep -q "$MOUNT_POINT" /etc/fstab; then
  echo "    Updating existing fstab entry for $MOUNT_POINT"
  sed -i "/$MOUNT_POINT/ c\\$FSTAB_ENTRY" /etc/fstab
else
  echo "    Appending new fstab entry for $MOUNT_POINT"
  echo "$FSTAB_ENTRY" >> /etc/fstab
fi

# Mount now
mount -a

############################
# 3) INSTALL APT DEPENDENCIES
############################
echo "==> Installing prerequisites (nginx, make, curl, etc.)"
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y \
  ca-certificates \
  curl \
  nginx \
  make \
  software-properties-common

############################
# 4) INSTALL DOCKER
############################
echo "==> Installing Docker Engine"

# Prepare Docker’s official repository
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

ARCH=$(dpkg --print-architecture)
. /etc/os-release
echo "deb [arch=$ARCH signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $VERSION_CODENAME stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

# Ensure Docker service starts on boot
systemctl enable docker
systemctl start docker

# If you have a non-root user named “jfrog”, add it to docker group so it can run 'docker' without sudo.
if id "jfrog" &>/dev/null; then
  echo "    Adding user 'jfrog' to docker group"
  usermod -aG docker jfrog
fi

############################
# 5) CONFIGURE NGINX & SSL
############################
echo "==> Setting up NGINX configuration for JFrog (reverse proxy + SSL)"

# 5a) Remove default site if it exists
if [ -f /etc/nginx/sites-enabled/default ]; then
  rm /etc/nginx/sites-enabled/default
fi
if [ -f /etc/nginx/sites-available/default ]; then
  rm /etc/nginx/sites-available/default
fi

# 5b) Create a new NGINX server block for HTTP → HTTPS redirect
cat > /etc/nginx/sites-available/jfrog <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    # Redirect all HTTP to HTTPS
    return 301 https://\$host\$request_uri;
}
EOF

# 5c) Create a placeholder HTTPS server block (Certbot will update it)
cat > /etc/nginx/sites-available/jfrog-ssl <<EOF
server {
    listen 443 ssl http2;
    server_name $DOMAIN;

    # SSL certificates (Certbot will fill these in)
    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    # Reverse proxy to JFrog (port 8081)
    location / {
        proxy_pass http://127.0.0.1:8081/;
        proxy_set_header Host              \$host;
        proxy_set_header X-Real-IP         \$remote_addr;
        proxy_set_header X-Forwarded-For   \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# 5d) Enable both site files
ln -sf /etc/nginx/sites-available/jfrog /etc/nginx/sites-enabled/jfrog
ln -sf /etc/nginx/sites-available/jfrog-ssl /etc/nginx/sites-enabled/jfrog-ssl

# 5e) Test NGINX config & reload
nginx -t
systemctl reload nginx

# 5f) Install Certbot and request a Let’s Encrypt certificate
echo "==> Installing Certbot and obtaining Let's Encrypt SSL certificate for $DOMAIN"
DEBIAN_FRONTEND=noninteractive apt-get install -y certbot python3-certbot-nginx

# Non-interactive certificate issuance (will modify the jfrog-ssl block automatically)
certbot --nginx --non-interactive --agree-tos \
  --redirect --hsts --staple-ocsp \
  -m "$EMAIL" \
  -d "$DOMAIN"

# After this, Certbot will:
#   • install the valid cert and key under /etc/letsencrypt/live/$DOMAIN
#   • modify /etc/nginx/sites-available/jfrog-ssl to point to those files
#   • reload NGINX with the new SSL configuration

############################
# 6) INSTALL & RUN JFROG JCR
############################
echo "==> Installing JFrog Artifactory JCR via Docker"

# Prepare directories under the mounted disk
mkdir -p "$JFROG_HOME/artifactory/var/etc"
touch "$JFROG_HOME/artifactory/var/etc/system.yaml"

# Ensure the JFrog data directory is owned by UID 1030 (Artifactory’s internal user)
chown -R 1030:1030 "$JFROG_HOME"

# Launch container only if not already running
if ! docker ps -q -f name=jcr &>/dev/null; then
  docker run \
    --name jcr \
    --restart unless-stopped \
    -v "$JFROG_HOME/artifactory/var/":/var/opt/jfrog/artifactory \
    -d \
    -p 8081:8081 \
    -p 8082:8082 \
    releases-docker.jfrog.io/jfrog/artifactory-jcr:7.77.5
  echo "    JFrog JCR container started."
else
  echo "    JFrog JCR container 'jcr' already exists; skipping."
fi

echo "==> Startup script completed successfully."
