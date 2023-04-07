## jenkins.tf

resource "local_file" "jenkins" {
  content = <<-DOC
---
all:
  hosts:
    jenkins-master-01:
      ansible_host: ${yandex_compute_instance.jenkins-master01.network_interface.0.nat_ip_address}
    jenkins-agent-01:
      ansible_host: ${yandex_compute_instance.jenkins-agent01.network_interface.0.nat_ip_address}
  children:
    jenkins:
      children:
        jenkins_masters:
          hosts:
            jenkins-master-01:
        jenkins_agents:
          hosts:
              jenkins-agent-01:
  vars:
    ansible_connection_type: paramiko
    ansible_user: <user>
     DOC
  filename = "../jenkins/inventory/cicd/hosts.yml"

  depends_on = [
    yandex_compute_instance.jenkins-master01,
    yandex_compute_instance.jenkins-agent01
  ]
}
