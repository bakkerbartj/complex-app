resource "aws_elasticache_subnet_group" "multi-docker-cache-sg" {
  name       = "multi-docker-cache-sg"
  description= "multi-docker cache subnet group"
  subnet_ids = [aws_subnet.multi-docker-private-1.id,aws_subnet.multi-docker-private-2.id]
}

resource "aws_elasticache_cluster" "multi-docker-redis-instance" {
  cluster_id           = "multi-docker-redis"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  //  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.multi-docker-cache-sg.name
  security_group_ids   = ["${aws_security_group.multi-docker-sg.id}"]
}
