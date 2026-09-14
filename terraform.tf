terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # This backend for the state management and in this we use only the S3 bucket for the state management, for the locking use of the DynamoDB we use dynamodb_table="name".
  backend "s3" {

    bucket       = "remote-infra-state-bucket"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    # dynamodb_table was deprecated.(Use if you want to use the DynamoDB table for state locking)
  }
}


# Now after downloading the provider from the official terraform docs, then we need to install the AWS CLI for the account identity and access management. Download by official command on the AWS docs and then we have to configure the AWS CLI by using the AWS IAM resource by creating the a user and give permissions to the user and then generate the access key, and that's all.






