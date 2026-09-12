terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {

    bucket       = "remote-infra-state-bucket"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    # dynamodb_table was deprecated.
  }
}


# Now after downloading the provider from the official terraform docs, then we need to install the AWS CLI for the account identity and access management. Download by official command on the AWS docs and then we have to configure the AWS CLI by using the AWS IAM resource by creating the a user and give permissions to the user and then generate the access key, and that's all.






