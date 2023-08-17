variable "region" {
  type = string
  default = "us-east-1"
}

variable "availability_zone" {
  type = string
  default = "us-east-1b"
}

variable "aws_profile" {
  type = string
  default = "default"
}

variable "client_website_name" {
    type = string
}

variable "lightsail_blueprint" {
    type = string
    default = "wordpress"
}

variable "instance_size" {
  type        = string
  default     = "nano_1_0"
}

variable "user_data" {
  type = string
  default = "cd path/to/wp-content/themes && git clone https://github.com/320press/wordpress-bootstrap.git && npm install && grunt dev"
}