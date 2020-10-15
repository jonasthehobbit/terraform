variable "user_sql" {
  type    = string
  default = "testingconnections"
}
variable "pass_sql" {
  type    = string
  default = "testing1connections_1234!"
}
variable "app_service_name" {
    type = string
    description = "AppService name for the SQL service"
}
variable "location" {
    type = string
    description = "What you're calling this application service"
}