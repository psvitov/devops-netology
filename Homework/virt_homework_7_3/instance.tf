variable image { default =  "centos-7" }
variable instance_count { default = 1 }
variable name { default = ""}
variable count_format { default = "%01d" }
variable count_offset { default = 0 }
variable platform_id { default = "standard-v1"}
variable description { default =  "Test Terraform" }
variable zone { default =  "" }
variable folder_id { default =  "" }
variable cores { default = ""}
variable memory { default = ""}
variable core_fraction { default = ""}
variable boot_disk { default =  "" }
variable disk_size { default =  "" }
variable subnet_id { default = ""}
variable nat { default = ""}
variable users { default = "centos"}
variable instance_role { default =  "all" }


terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
}

data "yandex_compute_image" "image" {
  family = var.image
}

resource "yandex_compute_instance" "instance" {
  count = var.instance_count
  name = "${var.name}-${format(var.count_format, var.count_offset+count.index+1)}"
  platform_id = var.platform_id
  hostname = "${var.name}-${format(var.count_format, var.count_offset+count.index+1)}"
  description = var.description
  zone = var.zone
  folder_id = var.folder_id

  resources {
    cores  = var.cores
    memory = var.memory
    core_fraction = var.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      type = var.boot_disk
      size = var.disk_size
    }
  }
  network_interface {
    subnet_id = var.subnet_id
    nat       = var.nat
  }

  metadata = {
    ssh-keys = "${var.users}:${file("~/.ssh/id_rsa.pub")}"
  }
}

