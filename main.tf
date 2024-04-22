module "permissions" {
  source   = "./modules/permissions"
  for_each = var.roles

  name            = each.value.sso_assumable != null || var.application == null ? "${var.project}-${each.key}" : "${var.project}-${var.application}-${each.key}"
  namespace       = var.namespace
  policies        = each.value.policies == null ? [] : each.value.policies
  policy_arns     = each.value.policy_arns == null ? [] : each.value.policy_arns
  service_types   = each.value.service_types == null ? [] : each.value.service_types
  sso_assumable   = each.value.sso_assumable == null ? false : each.value.sso_assumable
  assume_accounts = each.value.assume_accounts == [] ? [] : each.value.assume_accounts
  tags            = var.tags
}
