resource "aws_security_group" "multi-docker-sg" {
  vpc_id = aws_vpc.multi-docker.id
  name = "multi-docker-sg"
  description = "multi docker security group"

  # Only postgres in
  ingress {
    from_port = 5432
    to_port = 6379
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}