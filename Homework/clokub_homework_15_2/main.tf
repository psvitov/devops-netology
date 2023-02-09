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
  zone      = var.yc_region
}

resource "yandex_resourcemanager_folder" "folder1" {
  cloud_id    = var.yc_cloud_id
  name        = "loadbalancer"
  description = "Load Balancer"
}

resource "yandex_iam_service_account" "sa" {
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
  name = "s-account"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

resource "yandex_storage_bucket" "bucket-loadb" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "psvitov-100223"
}

resource "yandex_storage_object" "foto-object" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "psvitov-100223"
  key        = "foto"
  source     = "/home/devops/Homeworks/15_2/15_2_1.png"
}

resource "yandex_vpc_network" "lb-net" {
  name = "balance-network"
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
}

resource "yandex_vpc_subnet" "lb-subnet" {
  v4_cidr_blocks = ["10.0.0.0/24"]
  zone           = var.yc_region
  name           = "public"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.lb-net.id}"
}

resource "yandex_lb_target_group" "tg" {
  name      = "target-group"
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
}

resource "yandex_compute_instance_group" "i-group" {
  name               = "ig-balancer"
  folder_id          = "${yandex_resourcemanager_folder.folder1.id}"
  service_account_id = "${yandex_iam_service_account.sa.id}"
  instance_template {
    platform_id = "standard-v3"
    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd8vfsrqdf7gdrf378vk"
      }
    }

    network_interface {
      network_id = "${yandex_vpc_network.lb-net.id}"
      subnet_ids = ["${yandex_vpc_subnet.lb-subnet.id}"]
      nat = "true"
    }

    metadata = {
      user-data = "${file("meta.txt")}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.yc_region]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  load_balancer {
    target_group_name  = "${yandex_lb_target_group.tg.id}"
  }

}

resource "yandex_lb_network_load_balancer" "lb" {
  name = "my-network-load-balancer"
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"

  listener {
    name = "my-listener"
    port = 8080
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = "${yandex_lb_target_group.tg.id}"

    healthcheck {
      name = "http"
      http_options {
        port = 80
      }
    }
  }
}
