resource "azurerm_storage_account" "dscterrpoc" {
  name                     = "jizdscterrpoc"
  resource_group_name      = "${azurerm_resource_group.dscterrpoc.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = "${local.common_tags}"
}

resource "azurerm_storage_container" "dsc" {
  name                  = "dsc"
  resource_group_name   = "${azurerm_resource_group.dscterrpoc.name}"
  storage_account_name  = "${azurerm_storage_account.dscterrpoc.name}"
  container_access_type = "blob"
}

