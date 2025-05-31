terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}

    provider "aws" {
        region = "us-east-1"
    }

resource "aws_vpc" "resume-vpc" {
        cidr_block = "10.0.0.0/16"

        tags = {
            Name = "resume-vpc"
        }
    }

    resource "aws_internet_gateway" "resume-igw" {
        vpc_id = aws_vpc.resume-vpc.id

        tags = {
            Name = "resume-igw"
        }
    
    }

    resource  "aws_route_table" "resume-route" {
        vpc_id = aws_vpc.resume-vpc.id

        route { 
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.resume-igw.id
        }

        tags = {
            Name = "resume-route"
        }
    }

    resource "aws_route_table_association" "resume-route_table-assoc" {
        subnet_id = aws_subnet.resume-subnet.id
        route_table_id = aws_route_table.resume-route.id
    }

    resource "aws_subnet" "resume-subnet" {
        vpc_id = aws_vpc.resume-vpc.id
        cidr_block = "10.0.2.0/24"

         tags = {
            Name = "resume-subnet"
        }

    } 

resource "aws_security_group" "resume-sg" {

 name = "allow tls"
 vpc_id = aws_vpc.resume-vpc.id
 egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  } 
 tags = {
  
  Name = "resume-sg"
 
}

}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.resume-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.resume-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_8080" {
  security_group_id = aws_security_group.resume-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}



    resource "aws_instance" "resume_master" {
        ami = "ami-084568db4383264d4"
        instance_type = "t2.micro"
        associate_public_ip_address = true
        key_name = "demokey"
        subnet_id = aws_subnet.resume-subnet.id
        vpc_security_group_ids = [aws_security_group.resume-sg.id]
        user_data = <<-EOF
                        #!/bin/bash
                        apt update
                        apt install nginx -y
                        apt install docker.io -y
                        apt install openjdk-17-jdk -y
                        wget -O /etc/apt/keyrings/jenkins-keyring.asc \
                        https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
                        echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
                        https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
                        /etc/apt/sources.list.d/jenkins.list > /dev/null
                        apt update
                        apt install jenkins -y
                        apt install ansible -y
                        mkdir -p /etc/ansible
                        echo "[webservers]" > /etc/ansible/hosts 
                        echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
                        echo "10.0.2.50 ansible_user=ubuntu" >> /etc/ansible/hosts
                        EOF
     tags = {
           Name = "master-server"
  } 
    }

resource "aws_instance" "node-server" {

 ami = "ami-084568db4383264d4"
 instance_type = "t2.micro"
 key_name = "demokey"
 user_data = <<-EOF
             #!/bin/bash
             apt update
             apt install openjdk-17-jdk -y
             apt install docker.io -y
             echo "ubuntu ALL=(ALL)  NOPASSWD: ALL" >> /etc/sudoers
             mkdir -p /home/ubuntu/.ssh
             echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINyWajpDOkQuAKKb5DheAPbjwJrLb+NTKcH2qSfoCUhJ jenkins@ip-10-0-2-67" > /home/ubuntu/.ssh/authorized_keys
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

 subnet_id = aws_subnet.resume-subnet.id
 private_ips     = ["10.0.2.50"]
 security_groups = [aws_security_group.resume-sg.id]

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



