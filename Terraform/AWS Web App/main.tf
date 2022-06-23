provider "aws" {
    region      = "us-east-2"
    access_key  = "${var.access_key}"
    secret_key  = "${var.secret_key}"
}

#architecture here we need 
#webfront and s3 bucket
#one subnet for each of our instances
https://hands-on.cloud/terraform-managing-aws-vpc-creating-public-subnet/
https://hands-on.cloud/terraform-managing-aws-vpc-creating-private-subnets/
#vpc internet gateway
#routing table
#routing table association
#security group for allowing HTTPS

resource "aws_vpc" "main_vpc" {
  cidr_block    = "10.0.0.0/16"
  tags          = {
    Name = "production-vpc"
  }
}


resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_internet_gateway.gw.id
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


#internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "internet-gw"
  } 
}


resource "aws_security_group" "webtrafic_sg" {
    name        = "allow_webtrafic_sg"
    description = "Allow inbound web trafic"
    vpc_id      = aws_vpc.main_vpc.id
    ingress {
        description = "HTTPS trafic from vpc"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    ingress {
        description = "HTTP trafic from vpc"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    ingress {
        description = "allow SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_block  = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    egress  {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    tags        = {
        Name = "allow_inbound_webtrafic_sg"
    }
}


resource "aws_launch_template" "webserver_template" {
  name = "webserver-template"


#this is good to know, but I'm not deploying it for money reasons
  # block_device_mappings {
  #   device_name = "/dev/sda1"

  #   ebs {
  #     volume_size = 20
  #   }
  # }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  image_id = "ami-530d5636"

  instance_type = "t2.micro"


#keyname? 
  key_name = "test"

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
  }

##this needs more research, can do group name
/*   placement {
    availability_zone = "us-west-2a"
  } */


  vpc_security_group_ids = [ aws_security_group.webtrafic_sg.id ]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web-app-instance"
    }
  }

#can specify a cloud init file here
  user_data = filebase64("${path.module}/example.sh")

}


resource "aws_elb" "web_balancer" {
  name            = 
  security_groups = [ aws_security_group.webtrafic_sg.id ]
  subnets         = [
    aws_subnet.public_us_east_2a.id,
    aws_subnet.public_us_east_2b.id,
    aws_subnet.public_us_east_2c.id
  ]

  cross_zone_load_balancing = true

  health_check {
    healthy_threshold = 2
    unhealthy_threashold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/" #may need to change
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 80
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
}







resource "aws_s3_bucket" "webpage" {
    bucket = "tanchwa-webpage"
    tags    = {
        Name = "tanchwa-webpage-bucket"
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

webfront


elestic load balancer

autoscaling group
resource "aws_launch_template" ""

##can specify load balancer in here
##make a target group and then  

database with read replica


https://hands-on.cloud/terraform-recipe-managing-auto-scaling-groups-and-load-balancers/
https://www.terraform.io/language/meta-arguments/for_each