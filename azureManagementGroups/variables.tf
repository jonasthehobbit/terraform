
variable "dateformat" {
  type        = string
  description = "(optional) describe your variable"
  default     = "YYYYMMDDhmm"
}
locals {
  groups = {
    oneten_root = {
      production = {
        displayname = "Management for production subscriptions with production policies applied"
        # subscriptions = {}
      }
      development = {
        displayname = "Management for production subscriptions with production policies applied"
        # subscriptions = {}
      }
    }
  }
}


