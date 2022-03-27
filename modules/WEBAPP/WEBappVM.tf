

resource "azurerm_linux_virtual_machine" "webApp" {
  count                           = var.instance_count
  name                            = "${var.webAppPrefix}-vm${count.index}"
  resource_group_name             = "${var.webAppPrefix}-resources"
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  availability_set_id             = var.availability_set_id
  disable_password_authentication = false
  network_interface_ids =[
    azurerm_network_interface.webApp[count.index].id,
  ]


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

resource "azurerm_network_interface" "webApp" {
  count               =  var.instance_count
  name                = "${var.webAppPrefix}-nic${count.index}"
  resource_group_name = "${var.webAppPrefix}-resources"
  location            = var.location
  
  ip_configuration {
    name                          = "primary"
    subnet_id                     = var.subnetID
    private_ip_address_allocation = "Dynamic"
  }
}



