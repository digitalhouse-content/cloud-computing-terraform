resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr
  enable_dns_support = var.enable-dns
  enable_dns_hostnames = var.enable-dns

  tags = {
    Name = "vpc-${var.subject}"
  }
}

resource "aws_subnet" "subnet_public_1" {
  vpc_id = aws_vpc.vpc.id

  cidr_block = var.subnets[0].cidr
  map_public_ip_on_launch = true
  availability_zone = var.subnets[0].az

  depends_on = [ aws_vpc.vpc ]

  tags = {
    Name = "${var.subject}-subnet-public-1"
  }
}

resource "aws_subnet" "subnet_public_2" {
  vpc_id = aws_vpc.vpc.id

  cidr_block = var.subnets[1].cidr
  map_public_ip_on_launch = true
  availability_zone = var.subnets[1].az

  depends_on = [ aws_vpc.vpc ]

  tags = {
    Name = "${var.subject}-subnet-public-2"
  }
}

resource "aws_subnet" "subnet_private_1" {
  vpc_id = aws_vpc.vpc.id

  cidr_block = var.subnets[2].cidr
  availability_zone = var.subnets[2].az

  depends_on = [ aws_vpc.vpc ]

  tags = {
    Name = "${var.subject}-subnet-private-1"
  }
}

resource "aws_subnet" "subnet_private_2" {
  vpc_id = aws_vpc.vpc.id

  cidr_block = var.subnets[3].cidr
  availability_zone = var.subnets[3].az

  depends_on = [ aws_vpc.vpc ]

  tags = {
    Name = "${var.subject}-subnet-private-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  depends_on = [ aws_vpc.vpc ]

  tags = {
    Name = "vpc-${var.subject}-igw"
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc.id

  depends_on = [ aws_vpc.vpc, aws_internet_gateway.igw ]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "vpc-${var.subject}-rt-public"
  }
}

resource "aws_route_table_association" "rt_public_as_1" {
  subnet_id = aws_subnet.subnet_public_1.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "rt_public_as_2" {
  subnet_id = aws_subnet.subnet_public_2.id
  route_table_id = aws_route_table.rt_public.id
}