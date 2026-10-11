# Terraform Lab

This directory is the starting point for the AWS Cloud Platform Lab.

## Safety first

- The current configuration intentionally creates **no AWS resources**.
- Never commit AWS access keys, passwords, MFA codes, state files, or private keys.
- Use AWS IAM Identity Center or a named AWS CLI profile where practical.
- Review every `terraform plan` before applying changes.
- A Terraform plan is not a spending limit; AWS Budgets alerts do not automatically stop usage.

## Prerequisites

- Terraform CLI >= 1.6
- AWS CLI v2
- An AWS identity configured locally with least-privilege permissions

## Validate locally

From this directory:

```bash
terraform fmt -check
terraform init
terraform validate
terraform plan
```

Initialization downloads provider plugins but does not create infrastructure. The plan should show no resource changes at this stage.

## Next milestones

1. Verify identity and region with read-only AWS CLI commands.
2. Add cost monitoring and least-privilege IAM guidance.
3. Design a small, explicitly reviewed resource-based exercise before applying anything.
