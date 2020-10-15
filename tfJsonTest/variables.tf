
variable "dateformat" {
  type        = string
  description = "(optional) describe your variable"
  default     = "YYYYMMDDhmm"
}
locals {
  config = {
    projectname = "ProjectTest"
    description = "Testing project to show locals block for config and for-each for multiple instances"
  }
  instances = {
    dev = {
      location = "UK West"
    }
    test = {
      location = "UK South"
    }
  }
  default_tags = {
    datecreated = "${formatdate(var.dateformat, timestamp())}"
    description = local.config.description
  }
}