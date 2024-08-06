#VPC
output "local_vpc_id_output" {
  value = aws_vpc.main.id
}

#To format the subnet ID's which may be multiples in format of subnet_name={id=, az=} 
locals {
  public_subnet_output = {
    for key, config in local.public_subnet: key => {
        subnet_id = aws_subnet.main[key].id
        az = aws_subnet.main[key].availability_zone
    }
  }

  private_subnet_output = {
    for key, config in local.private_subnet: key => {
        subnet_id = aws_subnet.main[key].id
        az = aws_subnet.main[key].availability_zone
    }
  }
}

output "local_public_subnets" {
  value = local.public_subnet_output
}

output "local_private_subnets" {
  value = local.private_subnet_output
}