variable "aws_region" {
  default = "eu-central-1"
}
variable "instance_type" {
  default = "t3.medium"
}
variable "key_name" {
  description = "Existing key pair name for SSH into EC2 (optional). Leave empty if not needed."
  type = string
  default = "vktravel"
}

variable "dockerhub_user" {
  description = "DockerHub username used in image names"
  type = string
  default = "vijaykankane"
}
