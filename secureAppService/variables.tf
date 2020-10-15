
variable "location" {
  type        = string
  description = "What you're calling this application service"
  default     = "northeurope"
}
variable "backup_location" {
  type    = string
  default = "westeurope"
}
variable "app_service_name" {
  type        = string
  description = "app service name"
  default     = "testapp"
}
variable "app_service_size" {
  type        = string
  description = "Plan you want for the app service B1/S1/P1v2 etc"
  default     = "S1"
}
variable "app_service_tier" {
  type        = string
  description = "Tier you want for the app service Basic/Standard"
  default     = "standard"
}
variable "app_service_kind" {
  type        = string
  description = "What app service version windows/linux?"
  default     = "windows"
}