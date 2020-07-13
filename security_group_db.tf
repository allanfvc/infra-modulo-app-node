resource "aws_security_group" "psql_sg" {

  name        = "psql_sg"
  description = "Configura o grupo de seguranca do PostgreSQL"
  vpc_id      = aws_vpc.app.id

  ingress {
    description = "Permite acesso ao PostgreSQL a partir do grupo de seguranca da aplicacao"
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  ingress {
    description = "Permite acesso SSH a partir do grupo de seguranca da aplicacao"
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "psql_sg"
  }
}