provider "aws" {
    region      = "us-east-2"
    access_key  = "${var.access_key}"
    secret_key  = "${var.secret_key}"
}


resource "aws_vpc" "main_vpc" {
  cidr_block    = "10.0.0.0/16"
  tags          = {
    Name = "production-vpc"
  }
}

resource "aws_key_pair" "aws_key" {
  key_name = "Superstar_pc_aws"
  public_key = file(var.public_key_path)
}

#internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "internet-gw"
  } 
}


resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "production-route-table"
  }
}


resource "aws_subnet" "public_us_east_2a" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Public-Subnet us-east-2a"
  }
}

resource "aws_subnet" "public_us_east_2b" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Public-Subnet us-east-2b"
  }
}

resource "aws_subnet" "public_us_east_2c" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2c"

  tags = {
    Name = "Public-Subnet us-east-2c"
  }
}


resource "aws_route_table_association" "a" {
    subnet_id = aws_subnet.public_us_east_2a.id
    route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "b" {
    subnet_id = aws_subnet.public_us_east_2b.id
    route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "c" {
    subnet_id = aws_subnet.public_us_east_2c.id
    route_table_id = aws_route_table.route_table.id
}


resource "aws_security_group" "elb_webtrafic_sg" {
    name        = "elb-webtraffic-sg"
    description = "Allow inbound web trafic to load balancer"
    vpc_id      = aws_vpc.main_vpc.id

    tags        = {
        Name = "elb-webtraffic-sg"
    }
}

resource "aws_security_group" "instance_sg" {
    name        = "instance-sg"
    description = "Allow traffic from load balancer to instances"
    vpc_id      = aws_vpc.main_vpc.id
    ingress {
        description = "web traffic from load balancer"
        security_groups  = [ aws_security_group.elb_webtrafic_sg.id ]
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
    }
    ingress {
        description = "web traffic from load balancer"
        security_groups  = [ aws_security_group.elb_webtrafic_sg.id ]
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
    }
    ingress {
        description = "ssh traffic from anywhere"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }
    egress {
        description = "all traffic out"
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }
    tags        = {
        Name = "instance-sg"
    }
}

#this is a workaround for the cyclical security group id call error

resource "aws_security_group_rule" "HTTP_from_vpc" {
  security_group_id        = aws_security_group.elb_webtrafic_sg.id
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "HTTPS_from_vpc" {
  security_group_id        = aws_security_group.elb_webtrafic_sg.id
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_SSH" {
  security_group_id        = aws_security_group.elb_webtrafic_sg.id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "all_traffic_out" {
  security_group_id        = aws_security_group.elb_webtrafic_sg.id
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "elb_egress_to_webservers" {
  security_group_id        = aws_security_group.elb_webtrafic_sg.id
  type                     = "egress"
  source_security_group_id = aws_security_group.instance_sg.id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "elb_tls_egress_to_webservers" {
  security_group_id        = aws_security_group.elb_webtrafic_sg.id
  type                     = "egress"
  source_security_group_id = aws_security_group.instance_sg.id
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
}

resource "aws_launch_template" "webserver_template" {
  name = "webserver-template"


/* this is good to know, but I'm not deploying it for money reasons
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  } */

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  image_id = "ami-02d1e544b84bf7502"


  instance_type = "t2.micro"

  key_name = aws_key_pair.aws_key.id

  monitoring {
    enabled = true
  }


  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [ aws_security_group.instance_sg.id ]
  }

  #vpc_security_group_ids = [ aws_security_group.webtrafic_sg.id ]

  lifecycle { 
    create_before_destroy = true
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web-app-instance"
    }
  }

  user_data = filebase64("nginx.sh")

}


resource "aws_elb" "web_balancer" {
  name            = "webapp-load-balancer"
  security_groups = [ aws_security_group.elb_webtrafic_sg.id ]
  subnets         = [
    aws_subnet.public_us_east_2a.id,
    aws_subnet.public_us_east_2b.id,
    aws_subnet.public_us_east_2c.id
  ]

  cross_zone_load_balancing = true

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/" 
  }


  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
}


resource "aws_autoscaling_group" "web_asg" {
  name = "${aws_launch_template.webserver_template.name}-asg"

  min_size             = 1
  desired_capacity     = 2
  max_size             = 4
  
  health_check_type    = "ELB"
  load_balancers = [ aws_elb.web_balancer.id ]
  
  launch_template {
    id           = aws_launch_template.webserver_template.id
    version      = aws_launch_template.webserver_template.latest_version
  }

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  vpc_zone_identifier  = [
    aws_subnet.public_us_east_2a.id,
    aws_subnet.public_us_east_2b.id,
    aws_subnet.public_us_east_2c.id,
  ]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }
}


output "elb_dns_name" {
  value = aws_elb.web_balancer.dns_name
}

resource "aws_autoscaling_policy" "web_scale_up" {
  name                   = "web-scaling-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

resource "aws_autoscaling_policy" "web_scale_down" {
  name = "web_policy_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}


resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name             = "web_cpu_alarm_up"
  comparison_operator    = "GreaterThanOrEqualToThreshold"
  evaluation_periods     = "2"
  metric_name            = "CPUUtilization"
  namespace              = "AWS/EC2"
  period                 = "120"
  statistic              = "Average"
  threshold              = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  alarm_description = "This metric monitors EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.web_scale_up.arn ]
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
  alarm_name             = "web_cpu_alarm_down"
  comparison_operator    = "LessThanOrEqualToThreshold"
  evaluation_periods     = "2"
  metric_name            = "CPUUtilization"
  namespace              = "AWS/EC2"
  period                 = "120"
  statistic              = "Average"
  threshold              = "10"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  alarm_description = "This metric monitors EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.web_scale_down.arn ]
}




/* resource "aws_s3_bucket" "webpage" {
    bucket = "Superstar-webpage"
    tags    = {
        Name = "Superstar-webpage-bucket"
    }
}
resource "aws_s3_bucket_website_configuration" "webpage_config" {
    bucket = aws_s3_bucket.webpage.id
    index_document {
        suffix = "index.html"
    }
    error_document {
        key = "error.html"
    }
}
resource "aws_s3_bucket_acl" "webpage_acl" {
  bucket = aws_s3_bucket.webpage.id
  acl    = "private"
}
 */

#webfront


#database with failover read replica
#Aurora database cluster primer
#Start Here:
#https://github.com/aws-ia/terraform-aws-rds-aurora/blob/main/main.tf#L95
#https://github.com/aws-ia/terraform-aws-rds-aurora/blob/main/variables.tf
#Get Here: 
#private subnets, db subnet groups,  rds cluster, rds cluster instance
#https://hands-on.cloud/terraform-managing-aws-vpc-creating-private-subnets/
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance

#still need a DB security group

#Questions: what is a global cluster vs non global cluster?
#what is a parameter group?
#I will probably have to associate the newly made private subnets with the route table
#maybe I will have to make a NAT gateway, and associate that with the routing table
#no, if I want it fully isolated from the internet, just route it within the vpc and the instances should get to it

#https://hands-on.cloud/terraform-recipe-managing-auto-scaling-groups-and-load-balancers/
#https://www.terraform.io/language/meta-arguments/for_each
