#output's created ec2's public ip add
output "ip_address" {
  value = module.app-server.webserver.public_ip
}