variable "do_pat" {
  type    = string
}

variable "project_name" {
  type    = string
  default = "simple-vm-tf-dev"
}

variable "project_environment" {
  type    = string
  default = "development"
}

variable "project_purpose" {
  type    = string
  default = "sandbox"
}

variable "vpc_name" {
  type    = string
  default = "simple-vm-tf-vpc"
}

variable "vpc_iprange" {
  type    = string
  default = "10.20.30.0/28"
}

variable "droplet_name" {
  type    = string
  default = "simple-vm-tf-droplet"
}

variable "droplet_region" {
  type    = string
  default = "nyc1"
}

variable "droplet_size" {
  type    = string
  default = "s-1vcpu-512mb-10gb"
}

variable "droplet_image" {
  type    = string
  default = "debian-11-x64"
}

variable "ssh_key_name" {
  type    = string
  default = "simple-vm-tf-sshkey"
}

variable "ssh_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "ssh_port" {
  type    = number
  default = 55022
}

variable "firewall_name" {
  type    = string
  default = "simple-vm-tf-firewall"
}
