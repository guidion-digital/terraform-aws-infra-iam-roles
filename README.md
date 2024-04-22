Simple helper module that creates IAM roles, and attaches provided policies from either provided ARNs or policy documents.

# Usage

_N.B. While it is possible to use all three modes of operation in a single role definition (sso, service, and account, see below), it's not advised, and may lead to unexpected allowances of who/what is allowed to assume the generated roles_ <!--- MD036 -->

There are three different usage patterns, with examples [here](./examples/):

- Provide `var.roles{}.service_types` for a service assumable role
- Provide `var.roles{}.assume_accounts` for an AWS account assumable role
- Provide `var.roles{}.sso_assumable` for an SSO assumable role (Google only)

It's useful to know that if you get the error "_The "for_each" set includes values derived from resource attributes that cannot be determined until apply_", you can get around this by using `var.policy_arns` instead of `var.policies`.
