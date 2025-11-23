output "instance_public_ip" {
  description = "Public IP of EC2 instance hosting frontend"
  value       = aws_instance.app.public_ip
}

output "instance_public_dns" {
  description = "Public DNS"
  value       = aws_instance.app.public_dns
}
