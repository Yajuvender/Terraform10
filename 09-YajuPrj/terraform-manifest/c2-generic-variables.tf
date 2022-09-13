

variable "aws_region" {

  description = "AWS Region where the resources will be provisioned"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment for which we create resources"
  type        = string
  default     = "dev"
}

variable "business_division" {
  description = "Business division for which we create resources"
  type        = string
  default     = "sap"
}

variable "projectname" {
  description = "This is the project using which i am developing"
  type        = string
  default     = "09-YajuPrj"
}