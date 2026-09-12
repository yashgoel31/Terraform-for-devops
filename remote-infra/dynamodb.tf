resource "aws_dynamodb_table" "lockid_table" {
  name         = "remote-infra-state-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "remote-infra-state-table"
  }
}