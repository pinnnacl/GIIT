provider "aws" {
  region = var.region
}

resource "aws_vpc" "nandu-vpc" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "nandu-vpc"
  }
}


resource "aws_subnet" "nandu-pub-subnet-1" {
  vpc_id     = aws_vpc.nandu-vpc.id
  cidr_block = "10.0.0.0/25"
  tags = {
    Name = "nandu-pub-subnet-1"
  }
}

resource "aws_subnet" "nandu-pvt-subnet-1" {
  vpc_id     = aws_vpc.nandu-vpc.id
  cidr_block = "10.0.0.128/25"
  tags = {
    Name = "nandu-pvt-subnet-1"
  }
}


resource "aws_internet_gateway" "nandu-igw" {
  vpc_id = aws_vpc.nandu-vpc.id
  tags = {
    Name = "nandu-igw"
  }
}

resource "aws_route_table" "nandu-route-table" {
  vpc_id = aws_vpc.nandu-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nandu-igw.id
  }

  tags = {
    Name = "nandu-route-table"
  }


}

