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

variable "subscription_id" {

}

variable "name_prefix" {
  type    = "string"
  default = "dscterrpoc"
}

variable "subnet_id" { }