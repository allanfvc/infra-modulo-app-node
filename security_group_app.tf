resource "aws_security_group" "app_sg" {

  name        = "app_sg"
  description = "Configura o grupo de seguranca da aplicacao"
  vpc_id      = aws_vpc.app.id

  ingress {
    description = "Permite acesso SSH a partir do ip publico do usuario"
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Permite acessar a aplicacao na porta 5000"
    from_port = 5000
    to_port   = 5000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Redireciona o acesso a aplicacao da porta 80 para a porta 5000"
    from_port = 80
    to_port   = 5000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Redireciona o acesso a aplicacao da porta 443 para a porta 5000"
    from_port = 443
    to_port   = 5000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app_sg"
  }
}