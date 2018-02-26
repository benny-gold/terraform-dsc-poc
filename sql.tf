resource "azurerm_public_ip" "sql" {
  name                         = "dscterrpoc-sql-ip"
  location                     = "${azurerm_resource_group.dscterrpoc.location}"
  resource_group_name          = "${azurerm_resource_group.dscterrpoc.name}"
  domain_name_label            = "jizzles-dsc-sql"
  public_ip_address_allocation = "Dynamic"
  tags                         = "${local.common_tags}"
}

resource "azurerm_network_interface" "sql" {
  name                      = "dscterrpoc-nic-sql"
  location                  = "${azurerm_resource_group.dscterrpoc.location}"
  resource_group_name       = "${azurerm_resource_group.dscterrpoc.name}"
  network_security_group_id = "${azurerm_network_security_group.dscterrpoc.id}"

  ip_configuration {
    name                          = "dscterrpoc-ipconfig"
    public_ip_address_id          = "${azurerm_public_ip.sql.id}"
    private_ip_address_allocation = "dynamic"
    subnet_id                     = "${var.subnet_id}"
  }

  tags = "${local.common_tags}"
}

resource "azurerm_virtual_machine" "sql" {
  name                             = "${var.name_prefix}sql"
  location                         = "${azurerm_resource_group.dscterrpoc.location}"
  resource_group_name              = "${azurerm_resource_group.dscterrpoc.name}"
  network_interface_ids            = ["${azurerm_network_interface.sql.id}"]
  vm_size                          = "Standard_A1"
  delete_data_disks_on_termination = "true"

  storage_os_disk {
    name              = "${var.name_prefix}sql-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.name_prefix}sql"
    admin_username = "ben"
    admin_password = "PleaseHackMeIts2001AndIDontKnowAboutInfoSec"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  tags = "${local.common_tags}"
}
