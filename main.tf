provider "aws" {
    region = "us-east-1"  
}

resource "aws_instance" "ec2-2024" {
  ami           = "ami-05fa00d4c63e32376" # us-west-2
  instance_type = "t2.micro"
  tags = {
      Name = "Terraform-Instance"
  }
}
