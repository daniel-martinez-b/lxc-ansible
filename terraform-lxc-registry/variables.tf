variable "proxmox_api_url" { type = string }
variable "proxmox_api_token_id" { type = string }
variable "proxmox_api_token_secret" { type = string }
variable "proxmox_ssh_password" { type = string }

variable "proxmox_node_1" { type = string }

variable "template_datastore_id" {
  type    = string
  default = "local"
}

variable "debian12_lxc_template_url" {
  default = "http://download.proxmox.com/images/system/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
}

variable "rootfs_datastore_id" {
  type    = string
  default = "pool1"
}

variable "registry_storage_datastore_id" {
  type    = string
  default = "pool1"
}

variable "registry_ct_id" {
  type    = number
  default = 180
}

variable "registry_hostname" {
  type    = string
  default = "oci-registry"
}

variable "registry_rootfs_gb" {
  type    = number
  default = 8
}

variable "registry_data_gb" {
  type    = number
  default = 100
}

variable "registry_root_password" {
  type      = string
  sensitive = true
}

variable "registry_ip_cidr" {
  type        = string
  description = "Static IP/CIDR for the container, e.g. 192.168.0.180/24"
}

variable "network_config" {
  type = object({
    bridge      = string
    gateway     = string
    domain      = string
    dns_servers = list(string)
  })
}
