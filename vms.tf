provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  version = "v1.1.1"
}

resource "azurerm_network_security_group" "dscterrpoc" {
  name                = "dscterrpoc-nsg"
  location            = "${azurerm_resource_group.dscterrpoc.location}"
  resource_group_name = "${azurerm_resource_group.dscterrpoc.name}"

  
  security_rule {
    name                       = "Rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 3389
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = "${local.common_tags}"
}


