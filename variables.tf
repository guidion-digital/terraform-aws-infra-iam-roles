variable "roles" {
  description = "Map of roles and their policies. See examples folder"

  type = map(object({
    policy_arns : optional(list(string)),
    policies : optional(list(string)),
    service_types : optional(list(string)),
    sso_assumable : optional(bool),
    assume_accounts : optional(list(string))
  }))

  validation {
    condition     = length([for this_role in var.roles : this_role.sso_assumable == null]) == 0 ? false : true
    error_message = "Please supply at least either service_types or sso_assumable"
  }
}

variable "application" {
  description = "Over-arching application you are calling this module for. e.g. The API Gateway name"
  default     = null
}

variable "namespace" {
  description = "Path used in IAM policy and role"
}

variable "project" {
  description = "Used for naming"
}

variable "tags" {
  description = "Additional tags to add"
  default     = {}
}

