variable "prefix" {
  default = "maples-tf-demo-basic"
}

variable "location" {
    type = string
    description = "Where do you want the VM's to be hosted?"
    default = "UK South"
}