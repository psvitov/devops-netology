terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_region
}

data "yandex_compute_image" "image" {
  family = "centos-7"
}

resource "yandex_compute_instance" "vm" {
  name        = "centos_7_test"
  platform_id = "standard-v1"
  zone        = var.yc_region
  folder_id = var.yc_folder_id

  resources {
      cores  = 2
      memory = 4
    }

  boot_disk {
    initialize_params {
      image_id = "image_id"
      type = "network-hdd"
      size = "40"
      }
    }
  network_interface {
    subnet_id = "subnet1"
    nat       = "false"
    }

    metadata = {
      ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
    }
}
