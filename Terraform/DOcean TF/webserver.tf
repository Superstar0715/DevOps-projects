data "template_file" "cloud-init" {
    template = file("${path.module}/cloud-init.yaml") #reminder to change this to make sure its exactly where the yaml
    vars = {
        init_ssh_public_key = file(var.pub_key)
    }
}
resource "digitalocean_droplet" "webserver" {
    image = "ubuntu-20-04-x64"
    name = "mtg_app_entry"
    region = "nyc1"
    size = "s-1vcpu-512mb"
    private_networking = true
    ssh_keys = [
        "${var.ssh_fingerprint}"
    ]
}

