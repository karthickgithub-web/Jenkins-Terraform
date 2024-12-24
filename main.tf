provider "aws" {
    region = "us-east-1"  
}

# Create a Security Group
resource "aws_security_group" "allow_traffic" {
  name        = "allow_traffic"
  description = "Allow inbound traffic on specified ports"

  # Inbound rules
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Be more restrictive in production (e.g., your IP)
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Be more restrictive in production
  }
    ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Be more restrictive in production
  }

  # Outbound rules (generally allow all outbound)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance
resource "aws_instance" "terraflow-instance" {
  ami           = "ami-05fa00d4c63e32376" # Replace with a valid AMI ID for your region. Amazon Linux 2 AMI is used here.
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.allow_traffic.id] # Attach the security group

  key_name = "Terraform-key" # Replace with your key pair name if you need to SSH

  tags = {
    Name = "Terraform-Instance"
    Environment = "Test"

  }
}

# Output the public IP of the instance
output "public_ip" {
  value = aws_instance.terraflow-instance.public_ip
}
