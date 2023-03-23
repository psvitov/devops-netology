resource "yandex_compute_instance" "master01" {
  folder_id = var.yc_folder_id
  name = "master01"
  zone = "ru-central1-a"
  hostname = "master01.ru-central1.internal"

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
#    ssh-keys = "devops:${file("./id_rsa.pub")}"
    user-data = "${file("./meta.txt")}" 
  }
}
