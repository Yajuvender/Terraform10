

variable "region" {
  description = "Region to be used for building this project"
  default     = "us-east-1"
}

variable "division" {
  description = "Business division of the organization"
  default     = "ecosystem"
}

variable "environment" {
  description = "Environment in which the project should be provisioned and deployed"
  default     = "dev"
}

variable "projectname" {
  description = "Project Name which will be added to all the names of resources"
  default     = "Prj14"
}