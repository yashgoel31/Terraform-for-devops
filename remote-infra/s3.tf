resource "aws_s3_bucket" "remote-s3" {
  bucket = "remote-infra-state-bucket"

  tags = {
    Name = "remote-infra-state-bucket"
  }
}