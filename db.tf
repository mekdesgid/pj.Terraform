#initialize resource group for my Data Base application machine

resource "azurerm_resource_group" "DB" {
  name     = "${var.DBPrefix}-resources"
  location = var.location
}

#creating  all the environment 

resource "azurerm_subnet" "DB" {
  name                 = "DBVnet"
  resource_group_name  = azurerm_resource_group.webApp.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.4.0/24"]
}

resource "azurerm_network_security_group" "DBNsg" {
  name                = "DBNsg"
  location            = azurerm_resource_group.DB.location
  resource_group_name = azurerm_resource_group.DB.name
}


resource "azurerm_subnet_network_security_group_association" "DB" {
  subnet_id                 = azurerm_subnet.DB.id
  network_security_group_id = azurerm_network_security_group.DBNsg.id
}

resource "azurerm_network_interface" "DB" {
  name                = "nicDB"
  resource_group_name = azurerm_resource_group.DB.name
  location            = azurerm_resource_group.DB.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.DB.id
    private_ip_address_allocation = "Dynamic"
  }
}


# Module      : APPLICATION VIRTUAL MACHIN 
# Description : This terraform module is used to create VM on Azure.

module "DB-VM" {
  source = "./modules/DB"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  network_interface_ids           = [azurerm_network_interface.DB.id]

}
