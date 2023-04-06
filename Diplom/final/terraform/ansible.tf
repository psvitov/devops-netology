resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 120"
  }

  depends_on = [
    local_file.inventory
  ]
}

resource "null_resource" "cluster" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ./ansible/inventory.ini kuberspray.yml"
  }

  depends_on = [
    null_resource.wait
  ]
}

resource "null_resource" "jenkins" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../jenkins/inventory/cicd/hosts.yml ../jenkins/site.yml"
  }

  depends_on = [
    null_resource.cluster
  ]
}
