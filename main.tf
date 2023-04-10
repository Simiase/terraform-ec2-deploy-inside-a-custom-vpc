resource "aws_vpc" "project_vpc" {
cidr_block        = "${var.project_vpc_cidr}"
instance_tenancy  =  "default"
tags = {
  "Name"          = "project_vpc"
}
}


resource "aws_internet_gateway" "gw" {
vpc_id           =   aws_vpc.project_vpc.id

tags = {
  "Name" = "gw"
}
}

resource "aws_route_table" "route" {
vpc_id          = aws_vpc.project_vpc.id

route{
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
}

tags = {
  "Name"        = "route"
}
}

resource "aws_security_group" "security" {
vpc_id          =  aws_vpc.project_vpc.id


ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  ingress{
  description        = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]  
  }

  tags = {
    Name     = "security"
  }
}

resource "aws_subnet" "private_subnet" {
vpc_id       = aws_vpc.project_vpc.id
 cidr_block  = "${var.private_subnet_cidr}" 

 tags = {
   "Name"    = "private_subnet"
 }
}

resource "aws_subnet" "public_subnet" {
vpc_id       = aws_vpc.project_vpc.id
 cidr_block  = "${var.public_subnet_cidr}" 

 tags = {
   "Name"    = "public_subnet"
 }
}

resource "aws_route_table_association" "b" {
subnet_id      = aws_subnet.public_subnet.id
route_table_id = aws_route_table.route.id
}

resource "aws_instance" "project_instance" {
ami                         = "ami-06e46074ae430fba6"
instance_type               =  "t2.micro"
key_name                    =  "ec2key"
associate_public_ip_address =  "true"
subnet_id                   = aws_subnet.public_subnet.id
security_groups             = [aws_security_group.security.id]
user_data                   = "${file("instance-sg-data.sh")}"

tags                        = {
     Name                   = "project_instance"
}
}
output "public_ipv4_address" {
    value                   = aws_instance.project_instance.public_ip
}

