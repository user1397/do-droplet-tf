terraform {

  required_version = ">= 1.4.6"

  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = ">= 2.28.1"
    }
  }
}

provider "digitalocean" {
  token = var.do_pat
}

resource "digitalocean_project" "project" {
  name        = var.project_name
  environment = var.project_environment
  purpose     = var.project_purpose
  resources   = [ digitalocean_droplet.droplet.urn ]
}

resource "digitalocean_ssh_key" "ssh_key" {
  name       = var.ssh_key_name
  public_key = file(var.ssh_key_path)
}

resource "digitalocean_vpc" "vpc" {
  name     = var.vpc_name
  region   = var.droplet_region
  ip_range = var.vpc_iprange
}

resource "digitalocean_droplet" "droplet" {
  name       = var.droplet_name
  region     = var.droplet_region
  size       = var.droplet_size
  image      = var.droplet_image
  monitoring = true
  vpc_uuid   = digitalocean_vpc.vpc.id
  user_data  = file("cloud-init.sh")
  ssh_keys   = [ digitalocean_ssh_key.ssh_key.fingerprint ]
}

resource "digitalocean_reserved_ip" "reserved_ip" {
  droplet_id = digitalocean_droplet.droplet.id
  region     = var.droplet_region
}

# Grab local public IP
data "http" "my_ip" {
  url = "http://ipinfo.io/ip"
}

resource "digitalocean_firewall" "firewall" {
  name        = var.firewall_name
  droplet_ids = [ digitalocean_droplet.droplet.id ]
  inbound_rule {
    protocol              = "tcp"
    port_range            = var.ssh_port
    source_addresses      = [ "${data.http.my_ip.response_body}/32" ]
  }
  inbound_rule {
    protocol              = "icmp"
    source_addresses      = [ "${data.http.my_ip.response_body}/32" ]
  }
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = [ "0.0.0.0/0"]
  }
  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = [ "0.0.0.0/0"]
  }
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = [ "0.0.0.0/0"]
  }
}
