terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}

    provider "aws" {
        region = "us-east-2"
    }


resource "aws_instance" "node-server" {

 ami = "ami-06c8f2ec674c67112"
 instance_type = "t2.micro"
 key_name = "demokeynew"
 user_data = <<-EOF
             #!/bin/bash
             apt update
             apt install openjdk-17-jdk -y
             apt install docker.io -y
             echo "ubuntu ALL=(ALL)  NOPASSWD: ALL" >> /etc/sudoers
             mkdir -p /home/ubuntu/.ssh
             echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEOZ4OlP086Z8FdiyPK2H7C2lcc2P9DJSil013a6EHIj jenkins@ip-10-0-2-100" > /home/ubuntu/.ssh/authorized_keys
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

 subnet_id = "subnet-00a46b30958642eee"
 private_ips     = ["10.0.2.50"]
 security_groups = ["sg-0b865de3f21d869e9"]

}

resource "aws_eip" "resume-eip" {
  domain                    = "vpc"
  associate_with_private_ip = "10.0.2.50"
}

resource "aws_eip_association" "eip-assoc" {
  allocation_id = aws_eip.resume-eip.id
  network_interface_id = aws_network_interface.resume-nif.id
  private_ip_address = "10.0.2.50"
}



