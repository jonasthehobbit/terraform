variable "config" {
    type = any
    description = "General configuration settings from locals block"
}
variable "instances" {
    type = any
    description = "How many instances you want to deploy, uses an array from the locals config"
}
variable "default_tags" {
    type = any
    description = "list of tags to include in the deployment - set in locals"
}
