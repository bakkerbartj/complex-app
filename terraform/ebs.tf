resource "aws_elastic_beanstalk_application" "multi-docker-app" {
  name        = "multi-docker-app"
  description = "multi-docker-app"
}

data "aws_elastic_beanstalk_solution_stack" "multi-docker-server" {
  most_recent = true
  name_regex = "^64bit Amazon Linux (.*) Multi-container Docker (.*)$"
}

resource "aws_elastic_beanstalk_environment" "multi-docker-env" {
  name                = "multi-docker-env"
  application         = aws_elastic_beanstalk_application.multi-docker-app.name
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.multi-docker-server.name
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.multi-docker.id
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.multi-docker-private-1.id},${aws_subnet.multi-docker-private-2.id}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "false"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.app-ec2-role.name
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.multi-docker-sg.id
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.elasticbeanstalk-service-role.name
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "public"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${aws_subnet.multi-docker-public-1.id},${aws_subnet.multi-docker-public-2.id}"
  }
  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "CrossZone"
    value     = "true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSize"
    value     = "30"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSizeType"
    value     = "Percentage"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = "Any 2"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType"
    value     = "Health"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REDIS_HOST"
    value     = aws_elasticache_cluster.multi-docker-redis-instance.cache_nodes[0].address
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REDIS_PORT"
    value     = "6379"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGUSER"
    value     = "postgres"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGPASSWORD"
    value     = "postgrespassword"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGHOST"
    value     = aws_db_instance.multi-docker-postgres-instance.endpoint
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGDATABASE"
    value     = "fibvalues"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGPORT"
    value     = "5432"
  }
}

