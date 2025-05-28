## AWX Terraform Deployment
*Use this Terraform module to deploy GKE cluster with AWX.*
Please note that you **must be** authorized with your **Google Service Account**.
#### Usage
1. Change variable ***project*** default in **stage-01-us-centarl1-awx.json** to your project id

2. Edit bucket name in ***config.gcs.tfbackend*** to your bucket name. 

*(This bucket will store the Terraform state)*

3. Init Terraform
``
make init
``

4. Apply Terraform configuration
``
make apply
``