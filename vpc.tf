# Internet VPC
resource "aws_vpc" "app" {
	cidr_block 		= "10.0.0.0/16"
	instance_tenancy 	= "default"
	enable_dns_support	= "true"
	enable_dns_hostnames 	= "true"
	enable_classiclink 	= "false"
	tags = {
		Name = "app"
	}
  depends_on = [aws_s3_bucket_object.upload]
}

resource "aws_internet_gateway" "app_igw" {
	vpc_id = aws_vpc.app.id
	tags = {
		Name = "app_igw"
	}
}

resource "aws_subnet" "public_subnet_1a"{
	vpc_id 			= aws_vpc.app.id
	cidr_block 		= "10.0.1.0/24"
	map_public_ip_on_launch = "true"
	availability_zone 	= "sa-east-1a"
	tags = {
		Name = "public_subnet_1a"
	}
	depends_on = [aws_vpc.app]
}

resource "aws_subnet" "private_subnet_1a"{
	vpc_id			= aws_vpc.app.id
	cidr_block 		= "10.0.2.0/24"
	map_public_ip_on_launch = "false"
	availability_zone 	= "sa-east-1a"
	tags = {
		Name = "private_subnet_1a"
	}
  depends_on = [aws_vpc.app]
}

resource "aws_route_table" "app_public_route"{
	vpc_id = aws_vpc.app.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.app_igw.id
	}
  depends_on = [aws_internet_gateway.app_igw]
	tags = {
		Name = "app_public_route"
	}
}

resource "aws_route_table_association" "apr_public_subnet_1a" {
	subnet_id 		= aws_subnet.public_subnet_1a.id
	route_table_id 		= aws_route_table.app_public_route.id
  depends_on = [aws_route_table.app_public_route]
}

resource "aws_eip" "nat" {
	vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
	allocation_id 	= aws_eip.nat.id
	subnet_id	= aws_subnet.public_subnet_1a.id
	depends_on  	= [aws_internet_gateway.app_igw, aws_eip.nat]
}

resource "aws_route_table" "nat_private_route" {
  vpc_id = aws_vpc.app.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  depends_on = [aws_nat_gateway.nat_gw]
  tags = {
    Name = "nat_private_route"
  }
}

resource "aws_route_table_association" "nat_private_route_1a" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.nat_private_route.id
}