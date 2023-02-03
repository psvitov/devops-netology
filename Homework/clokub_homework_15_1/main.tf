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
  name        = "cloud-network"
  description = "Cloud Networks"
}

resource "yandex_vpc_network" "cloud-net" {
  name = "cloudnetwork"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
}

resource "yandex_vpc_subnet" "cloud-subnet" {
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = var.yc_region
  name           = "public"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.cloud-net.id}"
}

resource "yandex_compute_instance" "nat" {
  name        = "nat-instance"
  platform_id = "standard-v1"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  zone        = var.yc_region

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8o8aph4t4pdisf1fio"
      type = "network-hdd"
      size = "10"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.cloud-subnet.id}"
    ip_address = "192.168.10.254"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "public-vm" {
  name        = "public-vm1"
  platform_id = "standard-v1"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  zone        = var.yc_region

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8jvcoeij6u9se84dt5"
      type = "network-hdd"
      size = "20"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.cloud-subnet.id}"
    nat = "true"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
resource "yandex_vpc_subnet" "private-subnet" {
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = var.yc_region
  name           = "private"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.cloud-net.id}"
}

resource "yandex_vpc_route_table" "rt" {
  name = "route-private"
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
  network_id = "${yandex_vpc_network.cloud-net.id}"

  static_route {
    destination_prefix = "192.168.20.0/24"
    next_hop_address   = "192.168.10.254"
  }
}

resource "yandex_compute_instance" "private-vm" {
  name        = "private-vm1"
  platform_id = "standard-v1"
  folder_id   = "${yandex_resourcemanager_folder.folder1.id}"
  zone        = var.yc_region

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8jvcoeij6u9se84dt5"
      type = "network-hdd"
      size = "20"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.private-subnet.id}"
    nat = "false"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
