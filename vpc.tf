resource "aws_vpc" "dev" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.dev.id
    tags = {
      Name = "${var.vpc_name}-igw"
    }
  
}

resource "aws_subnet" "subnets" {
    count = 3
    vpc_id = aws_vpc.dev.id
    cidr_block = element(var.cidr_block_subnets,count.index)
    availability_zone = element(var.azs,count.index)
  tags = {
    Name = "${var.vpc_name}-subnets${count.index+1}"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.vpc_name}-rt"
  }
}

resource "aws_route_table_association" "associate" {
    count = 3
    route_table_id = aws_route_table.rt.id
    subnet_id = element(aws_subnet.subnets.*.id,count.index)
  
}

resource "aws_security_group" "sg" {
    name = "eks-security-group"
    description ="allow eks rules"
    tags = {
        Name = "${var.vpc_name}-sg"
    }  
    ingress {
        to_port = 0
        from_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
       to_port = 0
        from_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"] 
    }
}