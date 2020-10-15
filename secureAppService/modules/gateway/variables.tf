variable "app_gateway_name" {
  type        = string
  description = "Name for the App Gateway"
  default     = "maples-hub-agw"
}
variable "gateway_cidr_block" {
  type    = list
  default = ["10.10.0.0/16"]
}
variable "app_service_name" {
    type = string
    description = "(optional) describe your variable"
}
variable "location" {
    type = string
    description = "(optional) describe your variable"
}
variable "hostname" {
    type = string
    description = "(optional) describe your variable"
}