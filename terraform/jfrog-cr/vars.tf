variable "project" {
  description = "Google cloud active project"
  type        = string
}

variable "image_type" {
  description = "The instance OS"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "instance_type" {
  description = "The instance type"
  type        = string
  default     = "e2-medium"
}

variable "app" {
  description = "The application name"
  type        = string
}

variable "region" {
  description = "The default region to deploy infrastructure"
  type        = string
}

variable "zone" {
  description = "The availability zone where the resource will be deployed"
  type        = string
}

variable "disk_size" {
  description = "The size of th disk"
  type        = string
  default     = "30"
}

variable "deletion_protection" {
  description = "Deletion protection for instances"
  type        = string
  default     = "false"
}
