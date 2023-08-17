resource "aws_lightsail_instance" "lightsail_instance" {
  name              = var.client_webiste_name
  availability_zone = var.availability_zone
  blueprint_id      = var.lightsail_blueprint
  bundle_id         = var.instance_size
  user_data         = var.user_data
}

resource "aws_lightsail_static_ip" "static_ip" {
  name = "${var.client_website_name}_static_ip"
}

resource "aws_lightsail_static_ip_attachment" "static_ip_attach" {
  static_ip_name = aws_lightsail_static_ip.static_ip.id
  instance_name  = aws_lightsail_instance.lightsail_instance.id
}