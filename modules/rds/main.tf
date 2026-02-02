resource "aws_security_group" "this" {
  name        = "rds-postgres-sg"
  description = "Security group do RDS PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    description = "Postgres do meu PC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${var.meu_ip}/32"]
  }

  ingress {
    description     = "Postgres vindo da API"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.api_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier = "rds-terraform"

  engine         = "postgres"
  engine_version = "17.6"
  instance_class = "db.t4g.micro"

  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = "postgres"
  username = var.db_username
  password = var.db_password

  publicly_accessible = true

  vpc_security_group_ids = [aws_security_group.this.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name
    
  deletion_protection       = true 
  skip_final_snapshot      = false
  final_snapshot_identifier = "rds-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  apply_immediately = false
  
  lifecycle {
    prevent_destroy = true  
    ignore_changes = [
      final_snapshot_identifier  
    ]
  }
}
