resource "azurerm_linux_virtual_machine" "DB-VM" {
  name                            = "DB-VM"
  resource_group_name             = "${var.DBPrefix}-resources"
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = var.network_interface_ids

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = "latest"
  }

  os_disk {
    storage_account_type = var.os_disk_type
    caching              = "ReadWrite"
  }
}

locals {
  instance_count = 2
}