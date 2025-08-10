terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.81.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
  insecure  = true

  ssh {
    username = "daniel"
    password = var.proxmox_ssh_password
  }
}

resource "proxmox_virtual_environment_download_file" "debian12_lxc" {
  node_name    = var.proxmox_node_1
  datastore_id = var.template_datastore_id
  content_type = "vztmpl"
  url          = var.debian12_lxc_template_url
  overwrite    = false
}

resource "proxmox_virtual_environment_container" "registry" {
  node_name     = var.proxmox_node_1
  vm_id         = var.registry_ct_id
  start_on_boot = true
  unprivileged  = true
#   features {
#     nesting = true
#     keyctl  = true
#     fuse    = true
#   }

  operating_system {
    template_file_id = proxmox_virtual_environment_download_file.debian12_lxc.id
  }

  console {
    enabled = true
    type    = "shell"
  }
  cpu {
    cores = 1
  }

  memory {
    dedicated = 1024
  }

  disk {
    datastore_id = "pool1"
    size         = 8
  }

  network_interface {
    name   = "eth0"
    bridge = var.network_config.bridge
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.registry_ip_cidr
        gateway = var.network_config.gateway
      }
    }
    dns {
      domain  = var.network_config.domain
      servers = var.network_config.dns_servers
    }
  }
}

output "registry_ip" {
  value = split("/", var.registry_ip_cidr)[0]
}
