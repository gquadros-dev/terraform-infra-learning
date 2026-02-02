output "nginx_public_ip" {
  value = module.nginx.public_ip
}

output "api_private_ip" {
  value = module.api.private_ip
}

output "rds_endpoint" {
  value = module.rds.endpoint
}

output "ssh_nginx_command" {
  value = "ssh -i ~/.ssh/aws-key ubuntu@${module.nginx.public_ip} -p 2214"
}