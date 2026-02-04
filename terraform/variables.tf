variable "aws-region" {
  description = "this the region used to launch resorces"
  type        = string
  default     = "ap-south-1"
}

variable "my_ip" {
  description = "my public ip for ssh access"
  type        = string
}