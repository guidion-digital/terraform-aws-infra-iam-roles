variable "name" {
  description = "Will be used for IAM policy naming"
}

variable "namespace" {
  description = "Path used in IAM policy and role"
}

variable "policies" {
  description = "Optional IAM policy document to create and attach to the IAM role that the application can assume"
  default     = []
}

variable "policy_arns" {
  description = "Optional list of ARNs of IAM policies to attach to the IAM role that the application can assume"
  type        = list(string)
  default     = []
}

variable "service_types" {
  description = "Needed in order to allow assumerole from these types"
  type        = list(string)
  default     = []

  validation {
    condition     = !contains([for this_type in var.service_types : contains(["lambda", "ec2", "ecs"], this_type)], false)
    error_message = "Valid service types are: lambda, ec2, ecs"
  }
}

variable "sso_assumable" {
  description = "Whether to allow the role to be assumed via SSO"
  type        = bool
  default     = false
}

variable "assume_accounts" {
  description = "Account IDs to allow to assume these roles"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Additional tags to add"
  default     = {}
}
