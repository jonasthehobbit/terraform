#nested config for iteration
variable "virtual_machines" {
  type = map
  default = {
    vm1 = {
      size      = "Standard_A1_v2"
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "16.04-LTS"
      version   = "latest"
    }
    vm2 = {
      size      = "Standard_A1_v2"
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "16.04-LTS"
      version   = "latest"
    }
  }
}
variable "project_name" {
  type        = string
  description = "(optional) describe your variable"
  default     = "maples-tf-demo-modules"
}
variable "location" {
  type        = string
  description = "(optional) describe your variable"
  default     = "UK South"
}
