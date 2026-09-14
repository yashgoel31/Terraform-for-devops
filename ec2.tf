#Key pair (login)

resource "aws_key_pair" "my_key" {
  key_name   = "${var.env}-terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
  #Here we use the file fuction to avoid the hardcode key and out of the screen line.

  tags = {
    Environment = var.env
  }
}

#VPC (Virtual Private Cloud) & Security Group
resource "aws_default_vpc" "default" {

}

#Security group
resource "aws_security_group" "my_security_group" {
  name        = "${var.env}-automate-sg"
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
    Name        = "${var.env}-automate-sg"
    Environment = var.env
  }
}


# ec2 instance
# To creating this ec2 instance we have to give permission to the IAM user for the ec2 instance creation.

# If we have to make another instance then we can just copy the resource block and change the name of the resource and the tags.

# Or we can use the count parameter to create multiple instances with the same configuration. Example: count = 2

resource "aws_instance" "my_instance" {
  #count = 2 # meta argument to create multiple instances with the same configuration. 

  for_each = tomap({
    automate-micro-1 = "t3.micro"
    automate-micro-2 = "t3.micro"
  })

  key_name = aws_key_pair.my_key.key_name

  security_groups = [aws_security_group.my_security_group.name]

  instance_type = each.value
  ami           = var.ec2_ami_id #Now this is not hardcoded, we just have to change the value in the variable.tf file and it will be reflected here.

  depends_on = [aws_security_group.my_security_group, aws_key_pair.my_key] #This is a meta argument that tells Terraform to create the security group and key pair before creating the instance.Means totally this instance was depends on the security group and key pair. So, we have to create the security group and key pair first before creating the instance.

  user_data = file("install_nginx.sh") #This will run the script to install nginx on the ec2 instance for the first time when the instance is created. This is called user data script.

  root_block_device {
    volume_size = var.env == "prd" ? 20 : var.ec2_root_storage_size #Conditionals
    volume_type = "gp3"
  }

  tags = {
    Name        = each.key
    Environment = var.env
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