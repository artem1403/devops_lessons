terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.39.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "aws-vm-1" {
	ami = "ami-00399ec92321828f5"
	instance_type = "t2.micro"
}
