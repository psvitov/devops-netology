## ansible.tf

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
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ./infrastructure/inventory/cicd/hosts.yml ./infrastructure/site.yml"
  }

  depends_on = [
    null_resource.wait
  ]
}
