variable "project" {
  description = "The project ID to create the resources in."
  type        = string
}
variable "env" {
  description = "Environment to deploy"
  type        = string
}
variable "region" {
  description = "The region to create the resources in."
  type        = string
}
variable "zone" {
  description = "The availability zone to create the sample compute instances in. Must within the region specified in 'var.region'"
  type        = string
}
variable "clusterName" {
  description = "cluster name to be created"
  default     = "gogs-cluster"
}
variable "minNode" {
  description = "Minimum Node Count"
  default     = "3"
}
variable "maxNode" {
  description = "Maximum Node Count"
  default     = "4"
}
variable "machine_type" {
  description = "Node Instance machine type"
}
variable "helm_repo" {
  description = "Link to your helm repository"
  type        = string
}
variable "jfrog_username" {
  description = "Jfrog username"
  type        = string
  sensitive   = true
  default     = "jenkins"
}
variable "jfrog_password" {
  description = "Jfrog password"
  type        = string
  sensitive   = true
}
variable "jfrog_email" {
  description = "Jfrog email used in K8s docker auth"
  type        = string
  default     = "admin@nuwm-diploma.pp.ua"
}
variable "mysql_username" {
  description = "MySQL username"
  type        = string
  default     = "gogs"
}
variable "mysql_db_name" {
  description = "MySQL Database Name"
  type        = string
  default     = "gogs"
}
variable "jfrog_registry" {
  description = "JFrog Docker registry URL"
  type        = string
}
variable "jfrog_repository" {
  description = "JFrog Docker repository name"
  type        = string
}
variable "gogs_build_tag" {
  description = "Gogs image tag to pull"
  type        = string
}
