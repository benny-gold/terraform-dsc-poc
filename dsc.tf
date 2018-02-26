data "template_file" "dsc" {
  template = "${file("dsc_template.ps1")}"

  vars {
    sql_vm_name = "${azurerm_virtual_machine.sql.name}"
    api_vm_name = "${azurerm_virtual_machine.api.name}"
    web_vm_name = "${azurerm_virtual_machine.web.name}"
  }
}

resource "local_file" "dsc"{
    content     = "${data.template_file.dsc.rendered}"
    filename = "${path.module}/dscterrpoc.ps1"
}

resource "null_resource" "zip_dsc" {
  triggers {
    # zip file is recreated every time ps1 is changed.
    dsc_sha1 = "${sha1(file("${path.module}/dscterrpoc.ps1"))}"
  }
  depends_on = ["local_file.dsc"]
  provisioner "local-exec" {
    
    interpreter = ["PowerShell", "-Command"]
    command = "Compress-Archive -Path ./dscterrpoc.ps1 -DestinationPath ./dscterrpoc.zip -force;terraform taint azurerm_storage_blob.dsc_config"

  }
}

resource "azurerm_storage_blob" "dsc_config" {
  name                   = "dscterrpoc.zip"
  resource_group_name    = "${azurerm_resource_group.dscterrpoc.name}"
  storage_account_name   = "${azurerm_storage_account.dscterrpoc.name}"
  storage_container_name = "${azurerm_storage_container.dsc.name}"
  type = "block"
  source                 = "C:\\git\\terraform-dsc-poc\\dscterrpoc.zip"
  attempts = 5
  depends_on = ["null_resource.zip_dsc"]
}



resource "azurerm_virtual_machine_extension" "web" {
  name                 = "web-dsc"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.dscterrpoc.name}"
  virtual_machine_name = "${azurerm_virtual_machine.web.name}"
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.72"

  depends_on = ["azurerm_storage_blob.dsc_config"]

  settings = <<SETTINGS
 {
        "configuration": {
            "url": "${azurerm_storage_blob.dsc_config.url}",
            "script": "dscterrpoc.ps1",
            "function": "dscterrpoc"
          }
        }
    

SETTINGS

  tags = "${local.common_tags}"
}
