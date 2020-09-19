resource "aws_db_subnet_group" "multi-docker-db-sg" {
  name       = "multi-docker-db-sg"
  subnet_ids = [aws_subnet.multi-docker-private-1.id,aws_subnet.multi-docker-private-2.id]

  tags = {
    Name = "multi-docker DB subnet group"
  }
}

resource "aws_db_instance" "multi-docker-postgres-instance" {
  allocated_storage        = 20 # gigabytes
  //    backup_retention_period  = 7   # in days
  db_subnet_group_name     = aws_db_subnet_group.multi-docker-db-sg.name
  engine                   = "postgres"
  engine_version           = "9.5.4"
  identifier               = "multi-docker-postgres"
  instance_class           = "db.t2.micro"
  multi_az                 = false
  name                     = "fibvalues"
  //   parameter_group_name     = "mydbparamgroup1" # if you have an updated configuration set
  password                 = "postgrespassword"
  port                     = 5432
  publicly_accessible      = true
  //    storage_encrypted        = true # you should always do this, not possible on the free tier
  storage_type             = "gp2"
  username                 = "postgres"
  vpc_security_group_ids   = ["${aws_security_group.multi-docker-sg.id}"]
  skip_final_snapshot      =  true
}