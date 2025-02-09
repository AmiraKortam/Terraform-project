output "public_subnet_az1_id" {
  value = aws_subnet.public_subnet_az1.id
}

output "public_subnet_az2_id" {
  value = aws_subnet.public_subnet_az2.id
}

output "allow_ssh_http_sg_id" {
  value = aws_security_group.allow_ssh_http.id
}


output "vpc_id" {
  value = aws_vpc.dev-vpc.id
}
