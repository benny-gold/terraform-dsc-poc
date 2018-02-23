
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

resource "azurerm_public_ip" "web" {
  name                         = "dscterrpocdscterrpoc-ip"
  location                     = "${azurerm_resource_group.dscterrpoc.location}"
  resource_group_name          = "${azurerm_resource_group.dscterrpoc.name}"
  domain_name_label            = "jizzles-dsc"
  public_ip_address_allocation = "Dynamic"
  tags                         = "${local.common_tags}"
}


data "azurerm_public_ip" "dscterrpoc_ds" {
    name = "${azurerm_public_ip.dscterrpoc.name}"
    resource_group_name = "${azurerm_resource_group.dscterrpoc.name}"
}

resource "azurerm_network_interface" "web" {
  name                      = "dscterrpocdscterrpoc-nic"
  location                  = "${azurerm_resource_group.dscterrpoc.location}"
  resource_group_name       = "${azurerm_resource_group.dscterrpoc.name}"
  network_security_group_id = "${azurerm_network_security_group.dscterrpoc.id}"

  ip_configuration {
    name                          = "dscterrpocdscterrpoc-ipconfig"
    public_ip_address_id          = "${azurerm_public_ip.web.id}"
  }

  tags = "${local.common_tags}"
}

resource "azurerm_virtual_machine" "" {
  name                             = "${vm_name_prefix}webdscterrpocvm"
  location                         = "${azurerm_resource_group.dscterrpoc.location}"
  resource_group_name              = "${azurerm_resource_group.dscterrpoc.name}"
  network_interface_ids            = ["${azurerm_network_interface.web.id}"]
  vm_size                          = "Standard_A1"
  delete_data_disks_on_termination = "true"


  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${vm_name_prefix}web"
    admin_username = "ben"
    admin_password = "PleaseHackMeIts2001AndIDontKnowAboutInfoSec" 
  }


  tags = "${local.common_tags}"
}
