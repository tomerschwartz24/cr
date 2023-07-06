#Create a VPC resource 
resource "aws_vpc" "main" {
 cidr_block = "${var.vpc_cidr_block}"
 enable_dns_hostnames = true

 tags = {
   Name = "${var.vpc_name}"
 }
}


resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnets)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.public_subnets, count.index)
 availability_zone = element(var.azs, count.index)
 map_public_ip_on_launch = true
 
 tags = {
   Name = "${var.public_subnet_name}-${count.index + 1}"
 }
}
 
resource "aws_subnet" "private_subnets" {
 count      = length(var.private_subnets)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.private_subnets, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "${var.private_subnet_name}-${count.index + 1}"
 }
}

# Create an Internet Gateway in order to access the internet 
resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id
 
 tags = {
   Name = "${var.igw_name}"
 }
}


#Create NAT Gateway at element 0 (First public subnet)
resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.elastic_ip.id}"
  subnet_id     = "${aws_subnet.public_subnets[0].id}"

  tags = {
    Name = "${var.ngw_name}"
  }
}

#Create an Elastic IP for the NAT Gateway
resource "aws_eip" "elastic_ip" {
  domain = "vpc"

  tags = {
    Name = "${var.EIP_name}"
  }
}

#Route Table Creation for Public Subnets
resource "aws_route_table" "pub_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "${var.rt_full_out}"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.public_route_name}"
  }
}

#Route table Association with Public Subnets 
resource "aws_route_table_association" "pub_rt_assoc" {
    count          = length(aws_subnet.public_subnets)
    subnet_id      = "${aws_subnet.public_subnets[count.index].id}"
    route_table_id = "${aws_route_table.pub_route.id}"
}




#Route Table Creation for Private Subnets
resource "aws_route_table" "priv_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "${var.rt_full_out}"
    gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "${var.private_route_name}"
  }
}

#Route table Association with Private Subnets 
resource "aws_route_table_association" "priv_rt_assoc" {
    count          = length(aws_subnet.private_subnets)
    subnet_id      = "${aws_subnet.private_subnets[count.index].id}"
    route_table_id = "${aws_route_table.priv_route.id}"
}