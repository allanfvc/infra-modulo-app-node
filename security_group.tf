resource "aws_security_group" "allow_http" {
  name        = "sg_aula_web"
  description = "Permite trafego de entrada HTTP"
  vpc_id      = aws_vpc.app.id
  ingress {
    description = "Entrada HTTP de qualquer lugar"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_http"
  }
}

resource "aws_security_group" "allow_postgresql" {
  name        = "sg_aula_postgresql"
  description = "Permite que as maquinas do sg_aula_web conectem no postgresql"
  vpc_id      = aws_vpc.app.id
  ingress {
    description = "Acesso postgresql a partir do sg_aula_web"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.allow_http.id]
  }
  tags = {
    Name = "allow_postgresql"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "sg_aula_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.app.id
  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["179.70.13.118/32"]
  }
  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "web_egress" {
  name = "sg_aula_web_egress"
  description = "Permite trafego de saida para internet"
  vpc_id      = aws_vpc.app.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

