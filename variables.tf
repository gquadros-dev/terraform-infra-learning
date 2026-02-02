variable "db_password" {
  description = "Senha do RDS"
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "Usuário master do RDS"
  type        = string
  default     = "postgres"
}

variable "meu_ip" {
  description = "Seu IP para acesso ao RDS"
  type        = string
}