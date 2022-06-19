provider "aws" {
    region      = "us-east-1"
    access_key  = "${var.access_key}"
    secret_key  = "${var.secret_key}"
}


#VPC
resource "aws_vpc" "main" {
  cidr_block    = "10.0.0.0/16"
  tags          = {
    Name = "main"
  }
}


#buckets#
resource "aws_s3_bucket" "preprocessing" {
    bucket  = video-preprocessing-bucket
    acl     = "private"
    tags    = {
        Name = "Video Prepocessing Bucket"
    }
}
resource "aws_s3_bucket" "postprocessing" {
    bucket  = video-postprocessing-bucket
    acl     = "private"
    tags    = {
        Name = "Video Postprocessing Bucket"
    }
}
resource "aws_s3_bucket_website_configuration" "webpage" {
    bucket = AndrewTube.com
    acl = "public-read"
    policy = file("policy.json")
}


#security groups
resource "aws_security_group" "webtrafic-sg" {
    name        = "webtrafic-sg"
    description = "Allow inbound trafic on HTTPS"
    vpc         = aws_vpc.main.id #can I use a depends on? 
    depends_on  = aws_vpc
    ingress {
        description = "HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = 
    }
}


#allow access to post processing from lambda using IAM
