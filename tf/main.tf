################################################################################
# SETUP
################################################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
  profile = "home"
}

output "ssh" {
  value = "ssh ubuntu@${aws_instance.docs_gpt.public_dns}"
  description = "Command to ssh into the box"
}

################################################################################
# NETWORKING
################################################################################

resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = ""
      from_port        = 22  # ssh
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    }, 
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = ""
      from_port        = 80  # http
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    }
  ]
  tags = {
    Name = "docs_gpt_sg"
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

################################################################################
# STORAGE
################################################################################

# resource "aws_ebs_volume" "main" {
#   availability_zone = "us-west-2a"
#   size              = 50
# }

################################################################################
# INSTANCE
################################################################################

resource "aws_instance" "docs_gpt" {
  ami                         = "ami-0fcf52bcf5db7b003"  # Ubuntu
  instance_type               = "t3.xlarge"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids      = [ aws_security_group.main.id ]

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 50
    volume_type = "gp2"
    delete_on_termination = false
  }

  tags = {
    Name = "docs_gpt"
  }
}