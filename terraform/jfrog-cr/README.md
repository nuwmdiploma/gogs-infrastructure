# Terraform code: Google Cloud Compute Engine VM, Disk, and VPC Setup

## Overview

This Terraform code sets up a Google Cloud Compute Engine VM instance with a disk, a public IP address, and an SSH key stored in Secret Manager.

## Resources

The code creates the following resources:

- **google_compute_instance**: Manages a Compute Engine VM instance
- **google_compute_address**: Allocates a public IP address
- **google_compute_disk**: Manages a persistent disk
- **tls_private_key**: Generates an SSH private key for the VM
- **google_secret_manager_secret**: Manages secrets in Google Cloud Secret Manager
- **google_secret_manager_secret_version**: Manages secret versions in Google Cloud Secret Manager


## Input Variables

| Name                          | Description                                | Type    |
|-------------------------------|--------------------------------------------|---------|
| `instance_type`               | The instance OS                            | string  |
| `image_type`                  | The instance type                          | string  |
| `disk_size`                   | The size of Jenkins disk                   | number  |
| `instance_deletion_protection`| The deletion protection policy             | bool    |
| `env`                         | The working environment                    | string  |
| `app`                         | The application name                       | string  |
| `region`                      | The default region to deploy infrastructure| string  |