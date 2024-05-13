#######
# VPC
#######

resource "aws_vpc" "POC" {
  cidr_block                       = "10.1.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  enable_dns_support               = true

  tags = {
    Name = "POC-VPC"
  }
}
###########
# Subnets
###########

resource "aws_subnet" "POC-Subnet-1" {
    vpc_id = aws_vpc.POC.id
    cidr_block = "10.1.0.0/24"
    availability_zone = "us-east-1e"
    tags = {
        Name = "POC-Subnet-1"
    }
}

resource "aws_subnet" "POC-Subnet-2" {
    vpc_id = aws_vpc.POC.id
    cidr_block = "10.1.1.0/24"
    availability_zone = "us-east-1b"
    tags = {
        Name = "POC-Subnet-2"
    }
}

resource "aws_subnet" "POC-Subnet-3" {
    vpc_id = aws_vpc.POC.id
    cidr_block = "10.1.2.0/24"
    availability_zone = "us-east-1e"
    tags = {
        Name = "POC-Subnet-3"
    }
}

resource "aws_subnet" "POC-Subnet-4" {
    vpc_id = aws_vpc.POC.id
    cidr_block = "10.1.3.0/24"
    availability_zone = "us-east-1b"
    tags = {
        Name = "POC-Subnet-4"
    }
}
##################
# Route Tables
##################

# Public
resource "aws_route_table" "POC-Public-Subs" {
    vpc_id = aws_vpc.POC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.POC-IGW.id
    }
    route {
        cidr_block = "10.1.0.0/16"
        gateway_id = "local"
    }
}

resource "aws_route_table_association" "POC-Public-Sub1" {
    subnet_id = aws_subnet.POC-Subnet-1.id
    route_table_id = aws_route_table.POC-Public-Subs.id
}

resource "aws_route_table_association" "POC-Public-Sub2" {
    subnet_id = aws_subnet.POC-Subnet-2.id
    route_table_id = aws_route_table.POC-Public-Subs.id
}

# Private
resource "aws_route_table" "POC-Private-Subs" {
    vpc_id = aws_vpc.POC.id
    route {
        cidr_block = "10.1.0.0/16"
        gateway_id = "local"
    }
}

resource "aws_route_table_association" "POC-Private-Sub1" {
    subnet_id = aws_subnet.POC-Subnet-3.id
    route_table_id = aws_route_table.POC-Private-Subs.id
}

resource "aws_route_table_association" "POC-Private-Sub2" {
    subnet_id = aws_subnet.POC-Subnet-4.id
    route_table_id = aws_route_table.POC-Private-Subs.id
}

########
## IGW
########

resource "aws_internet_gateway" "POC-IGW" {
    vpc_id = aws_vpc.POC.id

    tags = {
        Name = "POC-IGW"
    }
}

########
## ALB
########

resource "aws_lb" "POC-ALB" {
    name = "POC-ALB"
    internal = true
    load_balancer_type = "application"
    security_groups = [aws_security_group.POC-ALB-SG.id]
    subnets = [aws_subnet.POC-Subnet-3.id, aws_subnet.POC-Subnet-4.id]
}

resource "aws_lb_target_group" "POC-ALB-TG" {
    name = "POC-ALB-TG"
    port = 443
    protocol = "HTTPS"
    vpc_id = aws_vpc.POC.id
}

resource "aws_lb_listener" "POC-ALB-Listener" {
    load_balancer_arn = aws_lb.POC-ALB.arn
    port = "80"
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.POC-ALB-TG.arn
    }
}


########
# SG's
########

resource "aws_security_group" "standalone" {
    name = "POC-standalone-SG"
    description = "Allow basic traffic for standalone"
    vpc_id = aws_vpc.POC.id
}

resource "aws_vpc_security_group_ingress_rule" "standalone-HTTP" {
  security_group_id = aws_security_group.standalone.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_security_group" "POC-ALB-SG" {
    name = "POC-ALB-SG"
    description = "Allow HTTP traffic for Load Balancer"
    vpc_id = aws_vpc.POC.id
}

resource "aws_vpc_security_group_ingress_rule" "ALB-HTTP" {
  security_group_id = aws_security_group.POC-ALB-SG.id
  cidr_ipv4         = aws_vpc.POC.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

