# List
variable "aws_ec2_config" {
  description = "type of ec2 instance"
  type = list(object({
    ami           = string
    instance_type = string
  }))
}


#Map
variable "aws_ec2_map" {
  description = "type of ec2 instance"
  type = map(object({
    ami           = string
    instance_type = string
  }))
}
