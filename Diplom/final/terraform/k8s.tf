resource "local_file" "k8s" {
  content = <<-DOC
 
    # ## Configure 'ip' variable to bind kubernetes services on a
    # ## different ip than the default iface
    # ## We should set etcd_member_name for etcd cluster. The node that is not a etcd member do not need to set the value, or can set the empty$
    [all]
    master01.ru-central1.internal ansible_host=${yandex_compute_instance.master01.network_interface.0.ip_address} ip=${yandex_compute_instance.master01.network_interface.0.ip_address}
    node01.ru-central1.internal ansible_host=${yandex_compute_instance.node01.network_interface.0.ip_address} ip=${yandex_compute_instance.node01.network_interface.0.ip_address}
    node02.ru-central1.internal ansible_host=${yandex_compute_instance.node02.network_interface.0.ip_address} ip=${yandex_compute_instance.node02.network_interface.0.ip_address}
    node03.ru-central1.internal ansible_host=${yandex_compute_instance.node03.network_interface.0.ip_address} ip=${yandex_compute_instance.node03.network_interface.0.ip_address}


    [kube_control_plane]
    master01.ru-central1.internal

    [etcd]
    master01.ru-central1.internal

    [kube_node]
    node01.ru-central1.internal
    node02.ru-central1.internal
    node03.ru-central1.internal

    [calico_rr]

    [k8s_cluster:children]
    kube_control_plane
    kube_node
    calico_rr

    DOC
  filename = "./ansible/k8s.ini"

  depends_on = [
    yandex_compute_instance.master01,
    yandex_compute_instance.node01,
    yandex_compute_instance.node02,
    yandex_compute_instance.node03
  ]
}
