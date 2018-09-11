# Configure the Cloudflare provider
provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}


# Add a record to the domain
resource "cloudflare_record" "Add" {
  domain = "${var.cloudflare_zone}"
  name   = "${var.site_name}"
  value  =  "${scaleway_ip.add.ip}"
  type   = "A"
}
