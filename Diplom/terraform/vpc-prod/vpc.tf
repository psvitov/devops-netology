## vpc-prod

resource "yandex_compute_instance" "vpc" {
  count = var.vpc_count
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
  name = "${var.vpc}-${count.index+1}"
  zone = var.yc_region_a
  hostname = "${var.vpc}-${count.index+1}.ru-central1.internal"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8jvcoeij6u9se84dt5"
      size = "10"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.stage-subnet-b.id}"
    nat = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}
