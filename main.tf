
resource "azurerm_resource_group" "webApp" {
  name     = "${var.webAppPrefix}-resources"
  location = var.location
}

locals {
  instance_count = 2
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.webApp.location
  resource_group_name = azurerm_resource_group.webApp.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.webApp.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_lb_probe" "example" {
  resource_group_name = azurerm_resource_group.webApp.name
  loadbalancer_id     = azurerm_lb.example.id
  name                = "http-running-probe"
  port                = 8080
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.webAppPrefix}-pip"
  resource_group_name = azurerm_resource_group.webApp.name
  location            = azurerm_resource_group.webApp.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "webApp" {
  count               = local.instance_count
  name                = "${var.webAppPrefix}-nic${count.index}"
  resource_group_name = azurerm_resource_group.webApp.name
  location            = azurerm_resource_group.webApp.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_availability_set" "avset" {
  name                         = "${var.webAppPrefix}avset"
  location                     = azurerm_resource_group.webApp.location
  resource_group_name          = azurerm_resource_group.webApp.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_network_security_group" "webserver" {
  name                = "webserver"
  location            = azurerm_resource_group.webApp.location
  resource_group_name = azurerm_resource_group.webApp.name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "port8080"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "8080"
    destination_address_prefix = azurerm_subnet.internal.address_prefix
  }
}

resource "azurerm_lb" "example" {
  name                = "${var.webAppPrefix}-lb"
  location            = azurerm_resource_group.webApp.location
  resource_group_name = azurerm_resource_group.webApp.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "example" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_rule" "example" {
  resource_group_name            = azurerm_resource_group.webApp.name
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id       = azurerm_lb_backend_address_pool.example.id
  probe_id                       = azurerm_lb_probe.example.id
}

resource "azurerm_network_interface_backend_address_pool_association" "example" {
  count                   = local.instance_count
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
  ip_configuration_name   = "primary"
  network_interface_id    = element(azurerm_network_interface.webApp.*.id, count.index)
}

resource "azurerm_linux_virtual_machine" "webApp" {
  count                           = local.instance_count
  name                            = "${var.webAppPrefix}-vm${count.index}"
  resource_group_name             = azurerm_resource_group.webApp.name
  location                        = azurerm_resource_group.webApp.location
  size                            = "Standard_b1ls"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  availability_set_id             = azurerm_availability_set.avset.id
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.webApp[count.index].id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.webserver.id
}




# resource "azurerm_public_ip" "natPip" {
#   name                = "nat-pip"
#   resource_group_name = azurerm_resource_group.webApp.name
#   location            = azurerm_resource_group.webApp.location
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# resource "azurerm_nat_gateway" "example" {
#   name                    = "nat-Gateway"
#   location                = azurerm_resource_group.webApp.location
#   resource_group_name     = azurerm_resource_group.webApp.name
#   public_ip_address_ids   = [azurerm_public_ip.natPip.id]
#   sku_name                = "Standard"
#   idle_timeout_in_minutes = 10
# }

# resource "azurerm_subnet_nat_gateway_association" "example" {
#   subnet_id      = azurerm_subnet.internal.id
#   nat_gateway_id = azurerm_nat_gateway.example.id
# }