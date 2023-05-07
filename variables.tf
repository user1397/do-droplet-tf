variable "do_pat" {
  type        = string
  description = "DigitalOcean Personal Access Token"
}

variable "project_name" {
  type        = string
  default     = "tf-test-project"
}

variable "project_environment" {
  type        = string
  default     = "dev"
}

variable "project_purpose" {
  type        = string
  default     = "sandbox"
}

variable "droplet_name" {
  type        = string
  default     = "tf-test-droplet"
}

variable "droplet_region" {
  type        = string
  default     = "nyc1"
}

variable "droplet_size" {
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "droplet_image" {
  type        = string
  default     = "debian-11-x64"
}

variable "ssh_key_name" {
  type        = string
  default     = "tf-test-sshkey"
}

variable "ssh_key_path" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_port" {
  type        = number
  default     = 55022
}

variable "firewall_name" {
  type        = string
  default     = "tf-test-firewall"
}
