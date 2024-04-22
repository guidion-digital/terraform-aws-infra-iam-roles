run "roles" {
  module {
    source = "./examples/test_app"
  }

  command = plan

  # This module can't be tested with a plan run, since the outputs can't be
  # known until apply
  assert {
    condition     = module.roles.application_iam_role_arns != null
    error_message = "Role ARNs were not created"
  }
}

