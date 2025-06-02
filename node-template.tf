terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}

    provider "aws" {
        region = var.region
    }

variable "region" {
  description = "Describes the region within the availablity zone"
  default = "us-east-2"
  type = string
}


variable "subnet-id" {
  description = "The id of the subnet which was created from master-template"
  type = string
}

variable "ami" {
  description = "ami-image-id"
  default = "ami-04f167a56786e4b09"
  type = string
}

variable "instance-type" {
  description = "instance-type"
  default = "t2.micro"
  type = string
}

variable "key" {
  description = "key"
  default = "demokeynew"
  type = string
}

variable "security-group-id" {
  description = "The id of the security group which was created from master-template"
  type = string
}

variable "private-ip" {
	description = "The custom private ip you want to set for node (within the cidr block of vpc and subnet)"
	default = "10.0.2.50"
	type = string
  
}
resource "aws_instance" "node-server" {

 ami = var.ami
 instance_type = var.instance-type
 key_name = var.key
 user_data = <<-EOF
             #!/bin/bash
             apt update
             apt install openjdk-17-jdk -y
             apt install docker.io -y
             echo "ubuntu ALL=(ALL)  NOPASSWD: ALL" >> /etc/sudoers
             mkdir -p /home/ubuntu/.ssh
             echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/iAh8K55EaG4DgJdt+MaBgmABwde8gw7ODv9XyqJD7 jenkins@ip-10-0-2-100" > /home/ubuntu/.ssh/authorized_keys
              chown -R ubuntu:ubuntu /home/ubuntu/.ssh
              chmod 700 /home/ubuntu/.ssh
              chmod 600 /home/ubuntu/.ssh/authorized_keys
              EOF
           

            
 
 network_interface {
 
 network_interface_id = aws_network_interface.resume-nif.id
 device_index = 0


 }

 tags = {
 
 Name = "node-server"   
 
}

}

 resource "aws_network_interface" "resume-nif" {

 subnet_id = var.subnet-id
 private_ips     = [var.private-ip]
 security_groups = [var.security-group-id]

}

resource "aws_eip" "resume-eip" {
  domain                    = "vpc"
  associate_with_private_ip = var.private-ip
}

resource "aws_eip_association" "eip-assoc" {
  allocation_id = aws_eip.resume-eip.id
  network_interface_id = aws_network_interface.resume-nif.id
  private_ip_address = var.private-ip
}



