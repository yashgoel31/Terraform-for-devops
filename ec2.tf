#Key pair (login)

resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
  #Here we use the file fuction to avoid the hardcode key and out of the screen line.
}

#VPC (Virtual Private Cloud) & Security Group
resource "aws_default_vpc" "default" {

}

#Security group
resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "This will add a TF generated security group"
  vpc_id      = aws_default_vpc.default.id #interpolation


  #inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH from anywhere"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "for the Django app"
  }

  # We can create as many as port using ingress block as we want.

  #outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #semantically equals to all protocols
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  # Tags are the key-value pairs that help you identify your AWS resources. You can use tags to categorize your resources in different ways, for example, by purpose, owner, or environment.
  tags = {
    Name = "automate-sg"
  }
}


# ec2 instance
# To creating this ec2 instance we have to give permission to the IAM user for the ec2 instance creation.
resource "aws_instance" "my_instance" {
  key_name        = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.my_security_group.name]
  instance_type   = var.ec2_instance_type # "t3.micro"
  ami             = var.ec2_ami_id        #Now this is not hardcoded, we just have to change the value in the variable.tf file and it will be reflected here.

  user_data = file("install_nginx.sh") #This will run the script to install nginx on the ec2 instance for the first time when the instance is created. This is called user data script.

  root_block_device {
    volume_size = var.ec2_root_storage_size
    volume_type = "gp3"
  }

  tags = {
    Name = "terra-server"
  }
}

# To stop the instance we can use the following command:
# 1. aws ec2 stop-instances --instance-ids i-xxxxxxxxxxxxxxxxx

# 2. resource "aws_instance" "my_server" {
# instance_initiated_shutdown_behavior = "stop" <---------- this one add into the resource block to stop the instance when we shutdown the instance from the OS. (This is optional)
#}

# "terraform fmt" command is used to format the code in a standard way. It will not change the functionality of the code but will make it more readable and maintainable.

# "terraform import" command is used to import existing resources into Terraform. It will not create any new resources but will allow you to manage existing resources with Terraform.
#Example: terraform import aws_instance.my_instance i-xxxxxxxxxxxxxxxxx

# "terraform state list" command is used to list all the resources that are currently managed by Terraform.

# --target option is used to apply the changes to a specific resource. It will not affect any other resources. Example: terraform apply --target=aws_instance.my_instance OR terraform destroy --target=aws_instance.my_instance