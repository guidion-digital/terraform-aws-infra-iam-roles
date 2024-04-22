This full example shows everything in one go, but in day to day use you'll likely want to have separate invocations for the three different modes the module can run in.

The variable definitions are in full, but object fields are very limited in what you can do in their definitions, so the optional ones bear explaining:

Within the `var.roles` object:

- `policy_arns`: Optional list of IAM policy ARNs you wish to attach
- `policies`: Optional list of policy documents you wish to attach
- `service_types`: Defines the AWS services that can make use of the roles that will be created
- `sso_assumable`: Is a boolean that will enable SSO Google federated assume permissions, meaning you will be able to use this role when signing in from Google. It defaults to false
- `assume_account`: Is an optional string with an account ID that will be able to assume the role
