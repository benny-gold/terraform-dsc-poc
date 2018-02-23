locals {
  common_tags = {
    owner     = "benny-gold"
    important = "deleteme"
  }
}

variable "location" {
  type    = "string"
  default = "westeurope"
}

variable "subscription_id" {}

variable "vm_name_prefix" {
  type    = "string"
  default = "dscterrpoc"
}
