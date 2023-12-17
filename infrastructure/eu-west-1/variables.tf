variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "poweruser-username" {
  type = string
  default ="eks-poweruser"
}

variable "status" {
  type = string
  default = "Active"
}

variable "zone-name" {
  type = string
  default = "gaf-tech.com"
}