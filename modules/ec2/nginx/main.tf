resource "aws_security_group" "this" {
  name        = "ec2-nginx-sg"
  vpc_id      = var.vpc_id
  description = "Security group da EC2 Nginx"

  ingress {
    description = "SSH"
    from_port   = 2214
    to_port     = 2214
    protocol    = "tcp"
    cidr_blocks = ["${var.meu_ip}/32"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [aws_security_group.this.id]

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y nginx

    cat > /etc/nginx/sites-available/default <<'CONF'
    ${templatefile("${path.module}/nginx.conf.tpl", {
      api_private_ip = var.api_private_ip
    })}
    CONF

    systemctl restart nginx

    sudo sed -i 's/#Port 22/Port 2214/' /etc/ssh/sshd_config
    sudo systemctl restart sshd
  EOF

tags = {
  Name = "EC2-Nginx"
}
}
