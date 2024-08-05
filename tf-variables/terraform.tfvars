aws_instance_type = "t3.micro"

ec2_root_block_config = {
  v_size = 30
  v_type = "gp3"
}

additional_tags = {
  "DEPT" = "DEV"
  "PROJECT" = "MY-Project"
}