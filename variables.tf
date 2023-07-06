variable "region" {
    type = string
    description = "Region to deploy infrastructure in"
}

variable "azs" {
 type        = list(string)
 description = "List of Possible availability zones to be used"
}


variable "public_subnets" {
 type        = list(string)
 description = "Public Subnets"
}

variable "private_subnets" {
 type        = list(string)
 description = "Private Subnets"
}


variable "public_subnet_name" {
 type        = string
 description = "The name of the public subnet"
}

variable "private_subnet_name" {
 type        = string
 description = "The name of the private subnet"
}

variable "vpc_name" {
 type        = string
 description = "The name of the vpc"
}

variable "vpc_cidr_block" {
 type        = string
 description = "The cidr block of the vpc"
}

variable "igw_name" {
 type        = string
 description = "The name of the internet gateway"
}

variable "ngw_name" {
 type        = string
 description = "The name of the nat gateway"
}

variable "EIP_name" {
 type        = string
 description = "The name of the elastic-ip resource gateway"
}

variable "rt_full_out" {
 type        = string
 description = "full access to internet route "
}

variable "public_route_name" {
 type        = string
 description = "Public subnet route name"
}

variable "private_route_name" {
 type        = string
 description = "private subnet route name"
}