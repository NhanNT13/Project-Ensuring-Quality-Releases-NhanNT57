# Resource Group
variable "location" {
    type          = string
}
variable "resource_group" {
    type          = string
    default     = "Azuredevops"
}

# Resource VNetwork
variable "application_type" {
    type          = string
}
variable "resource_type" {
    type          = string
}
variable "virtual_network_name" {}
variable "address_space" {}
variable "address_prefix_test" {
    description = "The address prefix test"
    default     = "10.5.1.0/24"
}

