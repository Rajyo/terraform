resource "aws_vpc" "main" {
  cidr_block = var.vpc_config.cidr_block
  tags = {
    Name = var.vpc_config.name
  }
}

resource "aws_subnet" "main" {
  vpc_id   = aws_vpc.main.id
  for_each = var.subnet_config #key={cidr, az} each.key each.value 

  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}


locals {
  public_subnet = {
    #key={} if public is true in subnet_config
    for key, config in var.subnet_config: key => config if config.public
  }

  private_subnet = {
    #key={} if public is false in subnet_config
    for key, config in var.subnet_config: key => config if !config.public
  }
}

# If case of public subnet, make Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  count = length(local.public_subnet) > 0 ? 1 : 0
  # In case of use of count(as above), main(as above name) becomes list of gateways with only 1 internat gateway
}


# If case of public subnet, make Routing Table
resource "aws_route_table" "main" {
   count = length(local.public_subnet) > 0 ? 1 : 0
   # In case of use of count(as above), main(as above name) becomes list of route tables with only 1 route table
   vpc_id = aws_vpc.main.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.main[0].id
    }
}


# If case of public subnet, make Routing Table
resource "aws_route_table_association" "main" {
  for_each = local.public_subnet #public_subnet={}

  subnet_id = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.main[0].id
}