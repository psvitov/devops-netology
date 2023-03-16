## network.tf

resource "yandex_vpc_network" "prod-net" {
  name = "prod-network"
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
}

resource "yandex_vpc_subnet" "prod-subnet-a" {
  v4_cidr_blocks = ["10.1.10.0/24"]
  zone           = var.yc_region_a
  name           = "prod-a"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.prod-net.id}"
}

resource "yandex_vpc_subnet" "prod-subnet-b" {
  v4_cidr_blocks = ["10.1.20.0/24"]
  zone           = var.yc_region_b
  name           = "prod-b"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.prod-net.id}"
}

resource "yandex_vpc_subnet" "prod-subnet-c" {
  v4_cidr_blocks = ["10.1.30.0/24"]
  zone           = var.yc_region_c
  name           = "prod-c"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.prod-net.id}"
}
