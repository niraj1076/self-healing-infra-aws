output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "subnet_ids" {
  value = data.aws_subnets.public_azs.ids
}

output "ip" {
  value = var.my_ip
}


output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

output "ec2_instance_id" {
  value = aws_instance.web.id
}
