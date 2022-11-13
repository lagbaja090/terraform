provider "aws" {
  region     = var.region
}


resource "aws_vpc" "development-vpc" {
    cidr_block = var.cidr_blocks[0]
    tags = {
    Name = "aag-vpc"
  }
  
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = var.cidr_blocks[1]
  availability_zone = var.availability_zone

  tags = {
    Name = "aag-Subnet"
  }
}

data "aws_vpc" "my-vpc" {
    default = true
  
}

data "aws_vpc" "my-vpc-projecto" {
    cidr_block = var.cidr_blocks[2]
  
}

resource "aws_subnet" "existing-subnet-projecto" {
    vpc_id = data.aws_vpc.my-vpc-projecto.id
    cidr_block = var.cidr_blocks[3]
    availability_zone = var.availability_zone
  
}

resource "aws_subnet" "existing-subnet" {
    vpc_id = data.aws_vpc.my-vpc.id
    cidr_block = var.cidr_blocks[4]
    availability_zone = var.availability_zone
  
}

resource "aws_subnet" "existing-subnet-1" {
    vpc_id = data.aws_vpc.my-vpc.id
    cidr_block = var.cidr_blocks[5]
    availability_zone = var.availability_zone
  
}

resource "aws_subnet" "existing-subnet-2" {
    vpc_id = data.aws_vpc.my-vpc.id
    cidr_block = var.cidr_blocks[6]
    availability_zone = var.availability_zone
  
}