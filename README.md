# Terraform for DevOps

This repository is a practice project for learning the basics of Terraform and using it to provision AWS resources. It demonstrates how Terraform configuration is split into files, how resources reference one another, and how Terraform keeps track of infrastructure through a state file.

## What This Project Creates

When applied in an AWS account, this configuration is intended to create:

- An EC2 `t3.micro` instance in the `eu-west-1` region
- An AWS key pair named `terra-key-ec2` for EC2 login
- A default VPC security group named `automate-sg`
- A security group rule allowing SSH on port 22, HTTP on port 80, and application traffic on port 8000
- An S3 bucket named `yashgoel-terraform-bucket`
- A local file named `automate.txt` containing sample text

## Repository Files

| File | Purpose |
| --- | --- |
| `provider.tf` | Configures the AWS provider and selects the `eu-west-1` region. |
| `terraform.tf` | Declares the required AWS provider version and contains setup notes. |
| `ec2.tf` | Defines the EC2 key pair, default VPC, security group, and EC2 instance. |
| `s3.tf` | Defines the S3 bucket. |
| `main.tf` | Defines a local file resource created by Terraform. |
| `terra-key-ec2.pub` | Public SSH key used to create the AWS key pair. |
| `.terraform.lock.hcl` | Locks provider versions so Terraform uses repeatable dependencies. |
| `.gitignore` | Prevents generated files, state files, and the private key from being committed. |

## Prerequisites

Install and configure the following before using the project:

1. Terraform
2. AWS CLI
3. An AWS account and IAM user with permission to manage the resources in this project
4. A local SSH key pair, if the existing `terra-key-ec2` files are not available

Configure AWS credentials using the AWS CLI, for example:

```bash
aws configure
```

Do not put AWS access keys directly in Terraform files or commit them to Git.

## Using the Project

Initialize Terraform and download the required providers:

```bash
terraform init
```

Review the resources Terraform plans to create:

```bash
terraform plan
```

Apply the configuration:

```bash
terraform apply
```

When finished practicing, remove the resources to avoid ongoing AWS charges:

```bash
terraform destroy
```

## Important Local Files

Some files are needed locally but should not be shared or committed:

- `terra-key-ec2` is the private SSH key for the EC2 key pair. Keep it secret and protect its permissions. Only the public key, `terra-key-ec2.pub`, is used by Terraform.
- `terraform.tfstate` and `terraform.tfstate.backup` contain Terraform's record of managed infrastructure. They may contain resource details and sensitive values, so they are ignored by Git.
- `.terraform/` contains downloaded provider binaries and is recreated by `terraform init`; it is ignored by Git.
- `automate.txt` is generated locally by the `local_file` resource.

The `.gitignore` file is intentionally configured to keep these generated or sensitive files out of the repository.

## Security Notes

This project is for learning and should be reviewed before production use:

- SSH, HTTP, and port 8000 are currently open to `0.0.0.0/0`. Restrict these rules to trusted IP ranges for real deployments.
- The S3 bucket name must be globally unique. Change it if Terraform reports that the name is already in use.
- The AMI ID is region-specific. Update it when changing the AWS region or when the AMI is no longer available.
- Review IAM permissions and AWS costs before applying the configuration.