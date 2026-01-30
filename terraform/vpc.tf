data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "public_azs" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["ap-south-1a", "ap-south-1b"]
  }
}
