## Gogs application Terragrunt Deployment
*Use this Terragrunt code to deploy GKE cluster with Gogs application.*
Please note that you **must be** authorized with your **Google Service Account**:

##### **Use either set variable (powershell):**
  ```
    $env:GOOGLE_APPLICATION_CREDENTIALS = "<path\to\credentials.json>"
  ```
##### **Or login directly using gcloud:**
  ```
    gcloud auth application-default login
  ```

#### Usage
1. Set variable GOGS_ENV to desired environment name (environments folder must contain folder with the same name).
**All necessary variables must be passed in Jenkins pipeline**

2. Change settings in ``terragrunt.hcl`` Create bucket by using ``terragrunt apply`` in **tf_state** folder 
*(This bucket will store the Terraform state)*

3. Init Terragrunt with backend config
``
make init
``

4. Apply Terragrunt configuration
``
make apply
``

5. Healtcheck path for Ingress GKE Exposing Backend Service
``
/healthcheck
``