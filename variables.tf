variable "ec2_instance_type" {
  default = "t3.micro"
  type    = string
}

variable "ec2_root_storage_size" {
  default = 10
  type    = number
}

variable "ec2_ami_id" {
  default = "ami-06468be052a4195a6"
  type    = string
}

variable "env" {
  default = "prd"
  type    = string
}