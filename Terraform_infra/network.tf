terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.16.2"
        }
    }  
}

provider "aws" {
    profile = "sebastien"
    region  = "eu-west-3" 
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "k8s_thehardway vpc"
    }
}

resource "aws_subnet" "main" {
    vpc_id     = aws_vpc.main.id
    cidr_block = "10.0.0.0/24"
    tags = {
        Name = "kubernetes subnet"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "kubernetes internet gateway"
    }
}

resource "aws_route_table" "main" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
    tags = {
        Name = "kubernetes route table"
    }
}

resource "aws_route_table_association" "main" {
    subnet_id      = aws_subnet.main.id
    route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "main" {
    name = "kubernetes"
    description = "kubernetes security group"
    vpc_id = aws_vpc.main.id
    ingress {        
        protocol = "all"
        from_port = 0
        to_port = 65535
        cidr_blocks = ["10.0.0.0/16", "10.200.0.0/16"]
    } 
    ingress {
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        protocol = "tcp"
        from_port = 6443
        to_port = 6443
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        protocol = "tcp"
        from_port = 443
        to_port = 443
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        protocol = "icmp"
        from_port = -1
        to_port = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}
