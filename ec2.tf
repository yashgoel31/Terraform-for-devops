#Key pair (login)

resource aws_key_pair my_key {
    key_name = "terra-key-ec2"
    public_key = file("terra-key-ec2.pub")
    #Here we use the file fuction to avoid the hardcode key and out of the screen line.
}

#VPC (Virtual Private Cloud) & Security Group
resource "aws_default_vpc" "default"{

}

#Security group
resource "aws_security_group" "my_security_group"{
    name = "automate-sg"
    description = "This will add a TF generated security group"
    vpc_id = aws_default_vpc.default.id #interpolation


    #inbound rules
    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow SSH from anywhere"
    }

    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTP from anywhere"
    }

    ingress{
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "for the Django app"
    }

    # We can create as many as port using ingress block as we want.

    #outbound rules
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1" #semantically equals to all protocols
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
resource "aws_instance" "my-instance"{
    key_name = aws_key_pair.my_key.key_name
    security_groups = [aws_security_group.my_security_group.name]
    instance_type = "t3.micro"
    ami = "ami-06468be052a4195a6"

    root_block_device {
        volume_size = 10
        volume_type = "gp3"
    }

    tags = {
        Name = "terra-server"
    }
}