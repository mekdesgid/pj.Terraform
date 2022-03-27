# variables.tf file of virtual-machine module

variable "location" {
    type = string
    description = "Azure location "
    default = "eastus"
}

variable "vm_size" {
    type = string
    description = "size of the virtual machine"
    default = "Standard_b1ls"
}
variable "os_disk_type" {
    type = string
    description = "type of the os disk. example Standard_LRS"
    default = "Standard_LRS"

}

variable "image_publisher" {
    type = string
    description = "Azure image publisher"
    default = "Canonical"

}
variable "image_offer" {
    type = string
    description = "Azure image offer"
    default = "UbuntuServer"

}
variable "image_sku" {
    type = string
    description = "Azure image sku"
    default = "18.04-LTS"

}


variable "admin_password" {}

variable "admin_username" {}

variable "DBPrefix" {
  description = "The prefix which should be used for all resources connected to the database."
  default = "DB"
}

variable "network_interface_ids"{}
