provider "aws" {
    region      = "us-east-2"
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
    bucket  = "video-preprocessing-bucket"
    tags    = {
        Name = "video-preprocessing-bucket"
    }
}
resource "aws_s3_bucket_acl" "preprocessing_acl" {
  bucket = aws_s3_bucket.preprocessing.id
  acl    = "private"
}
resource "aws_s3_bucket" "postprocessing" {
    bucket  = "video-postprocessing-bucket"
    tags    = {
        Name = "video-postprocessing-bucket"
    }
}
resource "aws_s3_bucket_acl" "postprocessing_acl" {
  bucket = aws_s3_bucket.postprocessing.id
  acl    = "private"
}
resource "aws_s3_bucket_website_configuration" "webpage" {
    bucket = "AndrewTube.com"
    index_document {
        suffix = "index.html"
    }
    error_document {
        key = "error.html"
    }
}


#security groups
resource "aws_security_group" "webtrafic_sg" {
    name        = "allow_inbound_webtrafic_sg"
    description = "Allow inbound web trafic"
    ingress {
        description      = "HTTPS"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
    }
    ingress {
        description      = "HTTP"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
    }
    tags    = {
        Name = "allow_inbound_webtrafic_sg"
    }
}




#lambda functions
resource "aws_lambda_function" "video_search" {
    filename        = "LAMBDAPAYLOAD.zip"
    function_name   = "Video Search"
    role            = aws_iam_role.iam_for_search.arn
    runtime         = "python3.9"
}
resource "aws_lambda_function" "video_encoder" {
    filename        = "LAMBDAPAYLOAD2.zip"
    function_name   = "Video Encoder"
    role            = aws_iam_role.iam_for_search.arn
    runtime         = "python3.9"
}

#cloudfront distribution

