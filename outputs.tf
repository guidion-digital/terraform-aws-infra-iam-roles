output "application_iam_role_arns" {
  value = { for this_role, this_other in module.permissions : this_role => this_other.application_iam_role_arn }
}
