#initialize resource group for my web application machine
resource "azurerm_resource_group" "webApp" {
  name     = "${var.webAppPrefix}-resources"
  location = var.location
}



#creating  all the environment 
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



resource "azurerm_lb_probe" "lbProb" {
  resource_group_name = azurerm_resource_group.webApp.name
  loadbalancer_id     = azurerm_lb.LB.id
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

resource "azurerm_subnet_network_security_group_association" "webApp" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.webserver.id
}



resource "azurerm_lb" "LB" {
  name                = "${var.webAppPrefix}-lb"
  location            = azurerm_resource_group.webApp.location
  resource_group_name = azurerm_resource_group.webApp.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backendpool" {
  loadbalancer_id = azurerm_lb.LB.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_rule" "LBRule" {
  resource_group_name            = azurerm_resource_group.webApp.name
  loadbalancer_id                = azurerm_lb.LB.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id       = azurerm_lb_backend_address_pool.backendpool.id
  probe_id                       = azurerm_lb_probe.lbProb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "NIbackendPool" {
  count                   = local.instance_count
  backend_address_pool_id = azurerm_lb_backend_address_pool.backendpool.id
  ip_configuration_name   = "primary"
  network_interface_id    = element(local.webAppInterface.*.id, count.index)
}

# Module      : APPLICATION VIRTUAL MACHIN 
# Description : This terraform module is used to create VM on Azure.

module "webApp" {
    source = "./modules/WEBAPP"
    availability_set_id  = azurerm_availability_set.avset.id
    admin_username  = var.admin_username
    admin_password   = var.admin_password
    subnetID = azurerm_subnet.internal.id

}

locals {
  webAppInterface = module.webApp.interface
  instance_count = var.instance_count
}
