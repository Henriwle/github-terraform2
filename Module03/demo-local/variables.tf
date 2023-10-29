variable "location" {
  type        = string
  description = "Deployment Location"
  default     = "West Europe"
}

variable "rgname" {
  type        = string
  description = "Respurce Group Name"
  default     = "rg-demo-terraform"
}

variable "saname1" {
  type        = string
  description = "Storage Account Name"
}

variable "saname2" {
  type        = string
  description = "Storage Account Name"
}

variable "saname3" {
  type        = string
  description = "Storage Account Name"
}

variable "company" {
  type        = string
  description = "Company Name"
}

variable "project" {
  type        = string
  description = "Project name"
}

variable "billing_code" {
  type        = string
  description = "Billing Code"
}