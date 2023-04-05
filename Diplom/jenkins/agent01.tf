## agent01.tf

resource "yandex_compute_instance" "jenkins-agent01" {
  folder_id = "b1g51av8v48qip32jg1s"
  name = "jenkins-agent-01"
  zone = var.yc_region_a
  hostname = "jenkins-agent-01.ru-central1.internal"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8jvcoeij6u9se84dt5"
      size = "20"
    }
  }

  network_interface {
    subnet_id = "e9bjdahvi925mpo4sj4v"
    nat = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}
