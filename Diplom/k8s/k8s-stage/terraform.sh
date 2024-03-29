#!/bin/bash
## terraform.sh

masters=1
nodes=3

## inventory.tf

cat << EOF > inventory.tf
resource "local_file" "inventory" {
  content = <<-DOC
    # Ansible inventory containing variable values from Terraform.
    # Generated by Terraform.
    [master]
EOF

for (( i=1; i <= $masters; i++ ))
do

echo "    master-$i.ru-central1.internal ansible_host=\${yandex_compute_instance.master[$((i-1))].network_interface.0.nat_ip_address}" >> inventory.tf

done

cat << EOF >> inventory.tf

    [nodes]
EOF

for (( i=1; i <= $nodes; i++ ))
do

echo "    node-$i.ru-central1.internal ansible_host=\${yandex_compute_instance.node[$((i-1))].network_interface.0.nat_ip_address}" >> inventory.tf

done

cat << EOF >> inventory.tf
    DOC
  filename = "./ansible/inventory.ini"

  depends_on = [
    yandex_compute_instance.master,
    yandex_compute_instance.node
  ]
}
EOF


## k8s.tf

cat << EOF > k8s.tf
resource "local_file" "k8s" {
  content = <<-DOC

    # ## Configure 'ip' variable to bind kubernetes services on a
    # ## different ip than the default iface
    # ## We should set etcd_member_name for etcd cluster. The node that is not a etcd member do not need to set the value, or can set the empty$
    [all]
EOF

for (( i=1; i <= $masters; i++ ))
do

echo "    master-$i.ru-central1.internal ansible_host=\${yandex_compute_instance.master[$((i-1))].network_interface.0.ip_address} ip=\${yandex_compute_instance.master[$((i-1))].network_interface.0.ip_address}" >> k8s.tf

done

for (( i=1; i <= $nodes; i++ ))
do

echo "    node-$i.ru-central1.internal ansible_host=\${yandex_compute_instance.node[$((i-1))].network_interface.0.ip_address} ip=\${yandex_compute_instance.node[$((i-1))].network_interface.0.ip_address}" >> k8s.tf

done

cat << EOF >> k8s.tf
    [kube_control_plane]
EOF

for (( i=1; i <= $masters; i++ ))
do

echo "    master-$i.ru-central1.internal" >> k8s.tf

done

cat << EOF >> k8s.tf
    [etcd]
EOF

for (( i=1; i <= $masters; i++ ))
do

echo "    master-$i.ru-central1.internal" >> k8s.tf

done

cat << EOF >> k8s.tf
    [kube_node]
EOF

for (( i=1; i <= $nodes; i++ ))
do

echo "    node-$i.ru-central1.internal" >> k8s.tf

done

cat << EOF >> k8s.tf
    [calico_rr]
    [k8s_cluster:children]
    kube_control_plane
    kube_node
    calico_rr
    DOC
  filename = "./ansible/k8s.ini"

  depends_on = [
    yandex_compute_instance.master,
    yandex_compute_instance.node
  ]
}
EOF
