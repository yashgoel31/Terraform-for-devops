#resource aws_s3_bucket my_bucket {
# bucket = "yashgoel-terraform-bucket"
#}

#This is a example of the terraform code to create a S3 bucket with no error of duplicate bucket #name.
#resource "random_id" "bucket_suffix" {
#  byte_length = 4
#}

#resource "aws_s3_bucket" "my_bucket" {
#  bucket = "yashgoel-project-${random_id.bucket_suffix.hex}"
#}