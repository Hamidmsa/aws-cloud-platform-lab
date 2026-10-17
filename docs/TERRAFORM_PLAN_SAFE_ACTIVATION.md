# Terraform Plan: Safe Activation Runbook

This lab intentionally keeps Terraform plan disabled in GitHub Actions until state and AWS trust are verified.

## Safety rules

- Never run `terraform apply` from CI.
- Do not commit `terraform.tfstate`, plan files, AWS credentials, or OIDC role trust secrets.
- Do not enable the repository variable `TERRAFORM_PLAN_ENABLED=true` until the checklist below is complete.
- A plan is not safe merely because it exits successfully: review the proposed actions and confirm the state refers to the existing lab bucket.

## 1. Inspect the current local Terraform state

From PowerShell on the workstation where the lab was last managed:

```powershell
cd C:\Users\hamid\aws-cloud-platform-lab
$env:AWS_PROFILE = "terraform-lab"
$env:TF_VAR_bucket_name = "hamid-cloud-platform-lab-2026-demo"
Set-Location .\terraform
terraform workspace show
terraform state list
terraform state pull | Out-Null
```

These commands inspect local Terraform state; they do not create or modify AWS resources. Do not paste or upload the state file or its contents: state can contain sensitive values. If `terraform state list` reports no state or errors, stop and investigate rather than initializing against the live bucket.

Record locally whether the state contains:
- `aws_s3_bucket.lab`
- `aws_s3_bucket_versioning.lab`
- `aws_s3_bucket_server_side_encryption_configuration.lab`
- `aws_s3_bucket_public_access_block.lab`

## 2. Decide on state storage before CI

The current configuration does not declare a remote backend. A GitHub runner starts with no persistent local state, so a remote-state design must be chosen before a trustworthy CI plan can run.

Use a dedicated state bucket and DynamoDB locking only if the expected cost and account setup are acceptable; alternatively, use an approved existing remote backend. Do not reuse the application bucket blindly. Backend migration requires a backup and an explicit, reviewed migration step.

## 3. Configure GitHub OIDC

Configure an AWS IAM OIDC provider for `token.actions.githubusercontent.com` if one does not already exist. Create a dedicated role with a trust policy restricted to this repository and the intended branch/environment. Do not use root credentials or long-lived access keys.

Add this GitHub Actions repository secret:
- `AWS_ROLE_ARN`: ARN of the dedicated role.

The role needs only the permissions required to read the relevant state and inspect the resources in this lab. Validate the exact IAM permissions against the chosen backend and Terraform resources before enabling the job.

## 4. Enable the plan job only after verification

In GitHub repository settings, create an Actions variable:
- Name: `TERRAFORM_PLAN_ENABLED`
- Value: `true`

Before setting it, verify that:
- the remote backend is configured and contains the correct state;
- OIDC role trust is restricted to this repository;
- the role has no create/update/delete permissions beyond what is strictly necessary for plan refresh (prefer read-only);
- the plan job is triggered from a trusted branch or a reviewed pull request;
- no workflow step runs `terraform apply`.

## 5. Review each plan

For the existing bucket, an expected no-change plan is the goal. If the plan proposes creating the bucket again, replacing it, or deleting anything, disable the variable and investigate state/backend configuration. Do not approve or apply the plan until the cause is understood.

## Future AI SysOps direction

Keep the agent read-only initially: collect metrics and events, summarize evidence, and produce a recommendation. Any remediation should pass deterministic policy checks, least-privilege authorization, budget limits, audit logging, and human approval for impactful changes.
