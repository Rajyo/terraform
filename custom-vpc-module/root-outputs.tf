output "vpc_id_output" {
  value = module.my-custom-vpc.local_vpc_id_output
}

output "public_subnet_output" {
  value = module.my-custom-vpc.local_public_subnets
}

output "private_subnet_output" {
  value = module.my-custom-vpc.local_private_subnets
}