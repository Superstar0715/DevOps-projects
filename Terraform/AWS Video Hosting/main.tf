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
#these ACLS should be changed using resource: aws_s3_bucket_public_access_block
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
resource "aws_s3_bucket" "webpage" {
    bucket = "andrewtube"
    tags    = {
        Name = "andrewtube-bucket"
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


#security groups
resource "aws_security_group" "webtrafic_sg" {
    name        = "allow_webtrafic_sg"
    description = "Allow inbound web trafic"
    vpc_id      = aws_vpc.main_vpc.id
    ingress {
        description = "HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    egress  {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    tags        = {
        Name = "allow_inbound_webtrafic_sg"
    }
}




/* lambda functions
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
*/

#cloudfront distribution
#further reading 
#https://aws.amazon.com/blogs/networking-and-content-delivery/serving-compressed-webgl-websites-using-amazon-cloudfront-amazon-s3-and-aws-lambda/
#https://www.youtube.com/watch?v=mls8tiiI3uc

#things we need, origin domain id from bucket, protocol policy, caching behavior
resource "aws_cloudfront_distribution" "s3_distribution" {
    origin {
        domain_name = aws_s3_bucket.b.bucket_regional_domain_name
        origin_id   = local.s3_origin_id

        s3_origin_config {
            origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
        }
    } 

    enabled             = true
    is_ipv6_enabled     = true
    comment             = "Some comment"
    default_root_object = "index.html"

    logging_config {
        include_cookies = false
        bucket          = "mylogs.s3.amazonaws.com"
        prefix          = "myprefix"
    }

    aliases = []
  
    default_cache_behavior {
        allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = local.s3_origin_id

        forwarded_values {
            query_string = false

            cookies {
                forward = "none"
            }
        }

        viewer_protocol_policy = "allow-all"
        min_ttl                = 0
        default_ttl            = 3600
        max_ttl                = 86400
    }

    # Cache behavior with precedence 0 
    #we need to cache the videos... figure out where videos are
    ordered_cache_behavior {
        #do I select videos directory here? 
        path_pattern     = "/content/immutable/*"
        allowed_methods  = ["GET", "HEAD", "OPTIONS"]
        cached_methods   = ["GET", "HEAD", "OPTIONS"]
        target_origin_id = local.s3_origin_id

        forwarded_values {
            #can I use this to forward search queries to a DB?
            query_string = false
            headers      = ["Origin"]

            cookies {
                forward = "none"
            }
        }

        viewer_protocol_policy = "redirect-to-https"
        min_ttl                = 0
        default_ttl            = 86400
        max_ttl                = 31536000
        compress               = true
    }
}