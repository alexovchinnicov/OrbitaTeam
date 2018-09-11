provider "scaleway" {
  organization = "${var.scaleway_organization}"
  token        = "${var.scaleway_token}"
  region       = "par1"
#  region = "ams1"
}


resource "scaleway_ssh_key" "add" {
    key = "${file("${var.ssh_pub}")}"
}


#resource "scaleway_ip" "add" {
#  server = "${scaleway_server.add.id}"
#}

resource "scaleway_ip" "add" {}

data "scaleway_image" "ubuntu" {
  architecture = "x86_64"
  name         = "Ubuntu Mini Xenial 25G"
}

resource "scaleway_server" "add" {
    name  = "${var.site_name}"
#  image = "aecaed73-51a5-4439-a127-6d8229847145"
    image = "${data.scaleway_image.ubuntu.id}"
    type  = "START1-XS"
    public_ip = "${scaleway_ip.add.ip}"

connection {
        user = "root"
        timeout = "1m"
        agent = true
        type = "ssh"
	host = "${scaleway_ip.add.ip}"
	private_key = "${file("${var.ssh_key}")}"
    }


provisioner "remote-exec" {
        inline = [
            "echo net.ipv6.conf.all.disable_ipv6 = 1 >>  /etc/sysctl.conf",
            "echo net.ipv6.conf.default.disable_ipv6 = 1 >>  /etc/sysctl.conf",
            "echo net.ipv6.conf.lo.disable_ipv6 = 1 >>  /etc/sysctl.conf",
            "sysctl -p"
        ]
    }


provisioner "remote-exec" {
        inline = [
            "apt-get update",
#            "apt-get upgrade -y",
            "apt-get install -f -y mc git mariadb-server php7.0 php7.0-bcmath php7.0-bz2 php7.0-curl php7.0-gd php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-opcache php7.0-xml php7.0-zip apache2 apache2-utils libapache2-mod-geoip libapache2-mod-php7.0 libapache2-mod-rpaf libapache2-mod-ruid2"
        ]
    }


}

#resource "scaleway_volume" "add" {
#  name       = "${var.site_name}"
#  size_in_gb = 25
#  type       = "l_ssd"
#}

#resource "scaleway_volume_attachment" "volume_attach" {
#  server = "${scaleway_server.add.id}"
#  volume = "${scaleway_volume.add.id}"
#}

resource "scaleway_security_group" "http" {
  name        = "http"
  description = "allow HTTP and HTTPS traffic"
}

resource "scaleway_security_group_rule" "http_accept" {
  security_group = "${scaleway_security_group.http.id}"

  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 80
}

resource "scaleway_security_group_rule" "https_accept" {
  security_group = "${scaleway_security_group.http.id}"

  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 443
}



#output "site_ip" {
#  value = "${scaleway_ip.add.ip}"
#}