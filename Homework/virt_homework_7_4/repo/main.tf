# Provider

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
  required_version = ">= 0.13"
# Backend

  backend "s3" {
      endpoint   = "storage.yandexcloud.net"
      bucket     = "psvitovbucketopp152"
      region     = "ru-central1"
      key        = "terraform.tfstate"
      access_key = "YCAJElDQ8xPTm97SIzOSc09d7"
      secret_key = "YCOP0AgYp0knigY7qvIf4JZA2I8GN7lOOC-oaky5"

      skip_region_validation      = true
      skip_credentials_validation = true
      }

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

resource "yandex_compute_instance" "vm-centos" {
  name          = "centos-test"
  platform_id   = "standard-v1"
  zone          = var.yc_region
  folder_id     = var.yc_folder_id
  hostname      = "centos7.cloud"
  allow_stopping_for_update = true


  resources {
      cores  = 2
      memory = 4
    }
  
  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.image.id
      name        = "root-centos"
      type        = "network-nvme"
      size        = "50"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.default.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }

}
