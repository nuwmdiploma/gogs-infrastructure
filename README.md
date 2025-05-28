# Gogs Infrastructure
**This repository contains necessary files for Gogs application deployment on Google Cloud Platform**
## Summary
- jenkins
- docker
- terraform
- helm

### Jenkins
This folder contains Jenkinsfile for each pipeline used in this project.
### Terraform
This folder contains terraform files for creating the infrastructure.
**Warning: you must be logged in your Google account or add "terraform_creds" service account in your Jenkins.**
### Helm
This folder contains necessary Helm chart for GOGS application deployment in Kubernetes cluster.
### Docker
This folder contains Dockerfiles to build the images.