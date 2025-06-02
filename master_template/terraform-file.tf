terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}

variable "region" {
  description = "Describes the region within the availablity zone"
  default = "us-east-2"
  type = string
}
    provider "aws" {
        region = var.region
    }

variable "vpc-cidr" {
  description = "The vpc cidr block"
  default = "10.0.0.0/16"
  type = string
}

variable "subnet-cidr" {
  description = "The subnet cidr block"
  default = "10.0.2.0/24"
  type = string
}

variable "ami" {
  description = "ami-image-id"
  default = "ami-04f167a56786e4b09"
  type = string
}

variable "instance-type" {
  description = "instance-type"
  default = "t3.small"
  type = string
}

variable "key" {
  description = "key"
  default = "demokeynew"
  type = string
}

variable "role" {
  description = "iam-role"
  default = "CICD"
  type = string
}

variable "master-private-ip" {
  description = "private-ip-master"
  default = "10.0.2.100"
  type = string
}


resource "aws_vpc" "resume-vpc" {
        cidr_block = var.vpc-cidr

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
        cidr_block = var.subnet-cidr

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

resource "aws_vpc_security_group_ingress_rule" "allow_docker_7946_tcp" {
  security_group_id = aws_security_group.resume-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 7946
  ip_protocol       = "tcp"
  to_port           = 7946
}

resource "aws_vpc_security_group_ingress_rule" "allow_docker_7946_udp" {
  security_group_id = aws_security_group.resume-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 7946
  ip_protocol       = "udp"
  to_port           = 7946
}

resource "aws_vpc_security_group_ingress_rule" "allow_docker_4789_udp" {
  security_group_id = aws_security_group.resume-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 4789
  ip_protocol       = "udp"
  to_port           = 4789
}

resource "aws_vpc_security_group_ingress_rule" "allow_docker_2377" {
  security_group_id = aws_security_group.resume-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 2377
  ip_protocol       = "tcp"
  to_port           = 2377
}

resource "aws_instance" "resume-master" {
  ami                         = var.ami
  instance_type               = var.instance-type
  key_name                    = var.key
  iam_instance_profile = var.role

  user_data = <<-EOF
                        #!/bin/bash
                        apt update
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
                        apt install unzip -y
                        cd /tmp
                        wget https://releases.hashicorp.com/terraform/1.8.4/terraform_1.8.4_linux_amd64.zip
                        unzip terraform_1.8.4_linux_amd64.zip
                        mv terraform /usr/local/bin/
                        chmod +x /usr/local/bin/terraform
                        mkdir -p /etc/ansible
                        echo "[webservers]" > /etc/ansible/hosts
                        echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
                        echo "10.0.2.50 ansible_user=ubuntu" >> /etc/ansible/hosts
                EOF

network_interface {
    network_interface_id = aws_network_interface.niw-master.id
    device_index = 0
}

  tags = {
    Name = "master-server"
  }
}

resource "aws_network_interface" "niw-master" {
  subnet_id       = aws_subnet.resume-subnet.id
  private_ips     = [var.master-private-ip]
  security_groups = [aws_security_group.resume-sg.id]
}

resource "aws_eip" "eip-master" {
    domain = "vpc"
    associate_with_private_ip = var.master-private-ip
}

resource "aws_eip_association" "eip-assoc-master" {
    allocation_id = aws_eip.eip-master.id
    network_interface_id = aws_network_interface.niw-master.id
    private_ip_address = var.master-private-ip
}

output "security-group-id" {
  value = aws_security_group.resume-sg.id
}

output "subnet-id" {
  value = aws_subnet.resume-subnet.id
}
