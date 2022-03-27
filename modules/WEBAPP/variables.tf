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
    default = "16.04-LTS"

}

variable "instance_count" {
  description = "the amount of machines that will be created"
  default = 2
}


variable "availability_set_id" {}

variable "admin_password" {}

variable "admin_username" {}

variable "webAppPrefix" {
  description = "The prefix which should be used for all resources connected to the web app."
  default = "WA"
}

variable "subnetID"{
  
  type = string
}

variable "vnet" {
  default = "vnet"
}