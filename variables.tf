variable "webAppPrefix" {
  description = "The prefix which should be used for all resources connected to the web app."
  default = "WA"
}

variable "DBPrefix" {
  description = "The prefix which should be used for all resources connected to the database."
  default = "DB"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "eastus"
}

variable "vnet_address_space" { 
    type = list
    description = "Address space for Virtual Network"
    default = ["10.0.0.0/16"]
}


variable "storage_account_name" {
  type        = string
  description = "storageacc017"
}

variable "storage_container_name" {
  type        = string
  description = "container_blob_name"
}

