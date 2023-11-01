# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet co1 
resource "aws_eip" "eip_for_nat_gateway_co1" {
  domain   = "vpc"

  tags   = {
    Name = "nat gateway co1 eip"
  }
}

# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet co2
resource "aws_eip" "eip_for_nat_gateway_co2" {
  domain = "vpc"

  tags   = {
    Name = "nat gateway co2 eip"
  }
}

# create nat gateway in public subnet co1
resource "aws_nat_gateway" "nat_gateway_co1" {
  allocation_id = aws_eip.eip_for_nat_gateway_co1.id
  subnet_id     = var.public_subnet_co1_id

  tags   = {
    Name = "nat_gateway co1"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  depends_on = [var.internet_gateway]
}


# create nat gateway in public subnet co2
resource "aws_nat_gateway" "nat_gateway_co2" {
  allocation_id = aws_eip.eip_for_nat_gateway_co2.id
  subnet_id     = var.public_subnet_co2_id

  tags   = {
    Name = "nat gateway co2"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  # on the internet gateway for the vpc.
  depends_on = [var.internet_gateway]
}

# create private route table co1 and add route through nat gateway co1
resource "aws_route_table" "private_route_table_co1" {
  vpc_id            = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_co1.id
  }

  tags   = {
    Name = "private route table co1"
  }
}

# associate private app subnet co1 with private route table co1
resource "aws_route_table_association" "private_app_subnet_co1_route_table_co1_association" {
  subnet_id         = var.private_app_subnet_co1_id
  route_table_id    = aws_route_table.private_route_table_co1.id
}

# associate private data subnet co1 with private route table co1
resource "aws_route_table_association" "private_data_subnet_co1_route_table_co1_association" {
  subnet_id         = var.private_data_subnet_co1_id
  route_table_id    = aws_route_table.private_route_table_co1.id
}

# create private route table co2 and add route through nat gateway co2
resource "aws_route_table" "private_route_table_co2" {
  vpc_id            = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_co2.id
  }

  tags   = {
    Name = "private route table co2"
  }
}

# associate private app subnet co2 with private route table co2
resource "aws_route_table_association" "private_app_subnet_co2_route_table_co2_association" {
  subnet_id         = var.private_app_subnet_co2_id
  route_table_id    = aws_route_table.private_route_table_co2.id
}

# associate private data subnet co2 with private route table co2
resource "aws_route_table_association" "private_data_subnet_co2_route_table_co2_association" {
  subnet_id         = var.private_data_subnet_co2_id
  route_table_id    = aws_route_table.private_route_table_co2.id
}
