# Default
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# Internet VPC
resource "aws_vpc" "multi-docker" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "multi-docker"
  }
}

# Subnets
resource "aws_subnet" "multi-docker-public-1" {
  vpc_id                  = aws_vpc.multi-docker.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-central-1a"

  tags = {
    Name = "multi-docker-public-1"
  }
}

resource "aws_subnet" "multi-docker-public-2" {
  vpc_id                  = aws_vpc.multi-docker.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-central-1b"

  tags = {
    Name = "multi-docker-public-2"
  }
}

resource "aws_subnet" "multi-docker-public-3" {
  vpc_id                  = aws_vpc.multi-docker.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-central-1c"

  tags = {
    Name = "multi-docker-public-3"
  }
}

resource "aws_subnet" "multi-docker-private-1" {
  vpc_id                  = aws_vpc.multi-docker.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-central-1a"

  tags = {
    Name = "multi-docker-private-1"
  }
}

resource "aws_subnet" "multi-docker-private-2" {
  vpc_id                  = aws_vpc.multi-docker.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-central-1b"

  tags = {
    Name = "multi-docker-private-2"
  }
}

resource "aws_subnet" "multi-docker-private-3" {
  vpc_id                  = aws_vpc.multi-docker.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-central-1c"

  tags = {
    Name = "multi-docker-private-3"
  }
}

# Internet GW
resource "aws_internet_gateway" "multi-docker-gw" {
  vpc_id = aws_vpc.multi-docker.id

  tags = {
    Name = "multi-docker-gw"
  }
}

# route tables
resource "aws_route_table" "multi-docker-public-rt" {
  vpc_id = aws_vpc.multi-docker.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.multi-docker-gw.id
  }

  tags = {
    Name = "multi-docker-public-routing"
  }
}

# route associations public
resource "aws_route_table_association" "multi-docker-public-1-a" {
  subnet_id      = aws_subnet.multi-docker-public-1.id
  route_table_id = aws_route_table.multi-docker-public-rt.id
}

resource "aws_route_table_association" "main-public-2-a" {
  subnet_id      = aws_subnet.multi-docker-public-2.id
  route_table_id = aws_route_table.multi-docker-public-rt.id
}

resource "aws_route_table_association" "main-public-3-a" {
  subnet_id      = aws_subnet.multi-docker-public-3.id
  route_table_id = aws_route_table.multi-docker-public-rt.id
}

resource "aws_route_table" "multi-docker-private" {
  vpc_id = aws_vpc.multi-docker.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "main-multi-docker-1"
  }
}

# route associations private
resource "aws_route_table_association" "multi-docker-private-1-a" {
  subnet_id      = aws_subnet.multi-docker-private-1.id
  route_table_id = aws_route_table.multi-docker-private.id
}

resource "aws_route_table_association" "multi-docker-private-2-a" {
  subnet_id      = aws_subnet.multi-docker-private-2.id
  route_table_id = aws_route_table.multi-docker-private.id
}

resource "aws_route_table_association" "multi-docker-private-3-a" {
  subnet_id      = aws_subnet.multi-docker-private-3.id
  route_table_id = aws_route_table.multi-docker-private.id
}

# nat gw
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.multi-docker-public-1.id
  depends_on    = [aws_internet_gateway.multi-docker-gw]
}

