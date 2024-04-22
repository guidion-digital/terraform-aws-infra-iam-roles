locals {
  # Set to list of services that are allowed to do the assuming, if any are given
  services = [for this_service in var.service_types : "${this_service}.amazonaws.com"]
  # Set to allow this account's SSO, if sso_assumable is true
  federated_account = var.sso_assumable ? [data.aws_caller_identity.this.id] : []
  # Only needed because it must be a list for the for_each loop
  assume_accounts = var.assume_accounts != null ? var.assume_accounts : []
  # Set to a normal 'sts:AssumeRole' action if either services or an account ID are given to allow assuming for
  assume_normal_action = length(local.services) != 0 || var.assume_accounts != null ? ["sts:AssumeRole"] : []
  # Set to special 'sts:AssumeRoleWithSAML' action if we're told to allow SSO
  assume_sso_action = var.sso_assumable ? ["sts:AssumeRoleWithSAML"] : []
  # Put all the assume types we're allowing (AssumeRole and/or AssumeRoleWithSSO)
  actions = concat(local.assume_normal_action, local.assume_sso_action)
}

data "aws_caller_identity" "this" {}

data "aws_iam_policy_document" "this" {
  statement {
    actions = local.actions

    dynamic "principals" {
      for_each = local.services

      content {
        type        = "Service"
        identifiers = local.services
      }
    }

    dynamic "principals" {
      for_each = local.assume_accounts

      content {
        type        = "AWS"
        identifiers = local.assume_accounts
      }
    }

    dynamic "principals" {
      for_each = local.federated_account

      content {
        type        = "Federated"
        identifiers = ["arn:aws:iam::${principals.value}:saml-provider/GSuite"]
      }
    }

    dynamic "condition" {
      for_each = local.federated_account

      content {
        test     = "StringEquals"
        variable = "SAML:aud"
        values   = ["https://signin.aws.amazon.com/saml"]
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.name
  path               = "/${var.namespace}/"
  assume_role_policy = data.aws_iam_policy_document.this.json

  tags = var.tags
}

# If we're going to attach supplied polices, do this
resource "aws_iam_role_policy_attachment" "these" {
  count = length(var.policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = var.policy_arns[count.index]
}

# If we're going to create and attach policies, do this
resource "aws_iam_policy" "this" {
  for_each = toset(var.policies)

  name   = "aux-${var.name}"
  path   = "/${var.namespace}/"
  policy = each.value
  tags   = var.tags
}
resource "aws_iam_role_policy_attachment" "aux" {
  for_each = aws_iam_policy.this

  role       = aws_iam_role.this.name
  policy_arn = each.value.arn
}
