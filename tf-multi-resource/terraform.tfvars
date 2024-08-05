# List
aws_ec2_config = [{
  ami           = "ami-0ff591da048329e00" #ubuntu
  instance_type = "t2.micro"
  }, {
  ami           = "ami-0b36f2748d7665334" #amazon-linux
  instance_type = "t2.micro"
}]


# Map
aws_ec2_map = {
  "ubuntu" = {
    ami           = "ami-0ff591da048329e00"
    instance_type = "t2.micro"
  },
  "amazon-linux" = {
    ami           = "ami-0b36f2748d7665334"
    instance_type = "t2.micro"
  }
}
