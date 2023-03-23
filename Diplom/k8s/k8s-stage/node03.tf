resource "yandex_compute_instance" "node03" {
  folder_id = var.yc_folder_id
  name = "node03"
  zone = "ru-central1-a"
  hostname = "node03.ru-central1.internal"

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
    subnet_id = "${yandex_vpc_subnet.stage-subnet-a.id}"
    nat = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}" 
  }
}
