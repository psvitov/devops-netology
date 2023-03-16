## network.tf

resource "yandex_vpc_network" "stage-net" {
  name = "stage-network"
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
}

resource "yandex_vpc_subnet" "stage-subnet-a" {
  v4_cidr_blocks = ["10.0.10.0/24"]
  zone           = var.yc_region_a
  name           = "stage-a"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.stage-net.id}"
}

resource "yandex_vpc_subnet" "stage-subnet-b" {
  v4_cidr_blocks = ["10.0.20.0/24"]
  zone           = var.yc_region_b
  name           = "stage-b"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.stage-net.id}"
}

resource "yandex_vpc_subnet" "stage-subnet-c" {
  v4_cidr_blocks = ["10.0.30.0/24"]
  zone           = var.yc_region_c
  name           = "stage-c"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.stage-net.id}"
}

