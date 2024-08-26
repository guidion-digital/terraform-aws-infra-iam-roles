module "roles" {
  source = "../../"

  application = "test_app"
  project     = "test_project"
  namespace   = "testing"

  roles = {
    "test_sso_assumable" = {
      policy_arns   = ["arn:aws:iam::aws:policy/PowerUserAccess"],
      sso_assumable = true
    },

    "test_service" = {
      policy_arns   = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"],
      service_types = ["ec2", "ecs"]
    },

    "test_account" = {
      policies       = [data.aws_iam_policy_document.test.json],
      assume_account = "123456789012"
    }
  }
}

data "aws_iam_policy_document" "test" {
  statement {
    sid = "dns0"
    actions = [
      "route53:GetHostedZone",
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource"
    ]
    resources = [
      "arn:aws:route53:::hostedzone/TEST"
    ]
  }
}
