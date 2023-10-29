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

variable "saname" {
  type        = string
  description = "Storage Account Name"
}
