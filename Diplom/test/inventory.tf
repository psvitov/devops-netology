resource "local_file" "inventory" {
  content = <<-DOC

ansible_host=${yandex_compute_instance.master01.*.network_interface.0.nat_ip_address}


    DOC
  filename = "./ansible/inventory.ini"

  depends_on = [
    yandex_compute_instance.master01,
    yandex_compute_instance.node
  ]
}
