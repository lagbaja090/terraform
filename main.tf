provider "aws" {
  region     = var.region
}


resource "aws_vpc" "development-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
    Name = "${var.env_prefix}-vpc"
  }
  
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = "${var.env_prefix}-Subnet" 
  }
}

resource "aws_internet_gateway" "dev-igw" {
    vpc_id = aws_vpc.development-vpc.id
  
  tags = {
    Name = "${var.env_prefix}-igw" 
  }
}

/*resource "aws_route_table" "dev-rtb" {
  vpc_id = aws_vpc.development-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-igw.id
  } 
  tags = {
    Name = "${var.env_prefix}-rtb" 
  }
}

resource "aws_route_table_association" "dev-rtas" {
    subnet_id = aws_subnet.dev-subnet-1.id
    route_table_id = aws_route_table.dev-rtb.id
  
}*/

resource "aws_default_route_table" "main_route_table" {
    default_route_table_id = aws_vpc.development-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-igw.id
  }

  tags = {
    Name = "${var.env_prefix}-rtb-dft"
  }
}

resource "aws_route_table_association" "dft-rtas" {
    subnet_id = aws_subnet.dev-subnet-1.id
    route_table_id = aws_default_route_table.main_route_table.id
  
}

resource "aws_default_security_group" "default-sg" {
    vpc_id = aws_vpc.development-vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.local_ip] # or any other server Ip we are using to ssh
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
   egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

    tags = {
    Name = "${var.env_prefix}-default-sg"
  }
}

data "aws_ami" "latest-ami" {
    most_recent = true
    owners = [var.owners]
    filter {
        name = "name"
        values = [var.ami_name]

    }
  
}

resource "aws_key_pair" "my_key" {
    key_name = "aagkey"
    public_key = "${file(var.public_key)}"
  
}
resource "aws_instance" "dev-instance" {
    ami = data.aws_ami.latest-ami.id
    subnet_id = aws_subnet.dev-subnet-1.id
    instance_type = var.instance_type
    availability_zone = var.availability_zone
    vpc_security_group_ids = [aws_default_security_group.default-sg.id]
    associate_public_ip_address = true
    key_name = aws_key_pair.my_key.key_name

    user_data = file(var.script_name[0])
    tags = {
    Name = "${var.env_prefix}-1st-inst"
  }
    
}