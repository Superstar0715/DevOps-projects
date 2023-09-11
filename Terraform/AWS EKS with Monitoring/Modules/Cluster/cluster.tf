resource "aws_ecs_cluster" "logging_cluster" {
  name = "logging-cluster"

  configuration {
    log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name = awscloud_watch_log_group.SOMETHING.name
    }

  }
  setting {
    name = "containerInsights"
    value = "enabled" // enables Cloud Watch container insights
  }
}


resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.logging_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}