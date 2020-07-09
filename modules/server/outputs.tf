output "ip_publico" {
  value = aws_instance.server.public_ip
}
output "ip_privado" {
  value = aws_instance.server.private_ip
}
output "dns_publico" {
  value = aws_instance.server.public_dns
}