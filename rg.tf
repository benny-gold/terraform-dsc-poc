resource "azurerm_resource_group" "dscterrpoc" {
  name     = "jizzles-terra-dsc-poc"
  location = "${var.location}"

  tags = "${local.common_tags}"
}

