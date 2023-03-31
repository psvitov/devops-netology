# Дипломный практикум в Yandex.Cloud

## 1 этап выполнения


### Создание облачной инфраструктуры

<details>
    <summary><b>ЗАДАНИЕ</b></summary>

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи [Terraform](https://www.terraform.io/).

Особенности выполнения:

- Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов;
- Следует использовать последнюю стабильную версию [Terraform](https://www.terraform.io/).

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
2. Подготовьте [backend](https://www.terraform.io/docs/language/settings/backends/index.html) для Terraform:  
   а. Рекомендуемый вариант: [Terraform Cloud](https://app.terraform.io/)  
   б. Альтернативный вариант: S3 bucket в созданном ЯО аккаунте
3. Настройте [workspaces](https://www.terraform.io/docs/language/state/workspaces.html)  
   а. Рекомендуемый вариант: создайте два workspace: *stage* и *prod*. В случае выбора этого варианта все последующие шаги должны учитывать факт существования нескольких workspace.  
   б. Альтернативный вариант: используйте один workspace, назвав его *stage*. Пожалуйста, не используйте workspace, создаваемый Terraform-ом по-умолчанию (*default*).
4. Создайте VPC с подсетями в разных зонах доступности.
5. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.
6. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://www.terraform.io/docs/language/settings/backends/index.html) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.
</details>
   
---
### Решение:
---

1. Создадим файл `variables.tf`, пропишем в него основные переменные, используемые при работе с `Yandex.Cloud`:

```
variables.tf

variable "yc_token" {
    description = "OAuth-token Yandex.Cloud"
    default = "AQAAAAAARMfEA***************kcys-7P6_1k"
    sensitive = true
}

variable "yc_cloud_id" {
    description = "ID Yandex.Cloud"
    default = "b1g8************rdt7"
    sensitive = true
}

variable "yc_region_a" {
    description = "Region Zone A"
    default = "ru-central1-a"
}

variable "yc_region_b" {
    description = "Region Zone B"
    default = "ru-central1-b"
}

variable "yc_region_c" {
    description = "Region Zone C"
    default = "ru-central1-c"
}
```
2. Создадим файл `main.tf`, добавим в него настройки облачного провайдера, создание каталога и сервисного аккаунта с ролью `editor`:

```
### vpc-stage

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  zone      = var.yc_region_a
}

resource "yandex_resourcemanager_folder" "folder1" {
  cloud_id    = var.yc_cloud_id
  name        = "diplom-stage"
  description = "Diploma workshop"
}

resource "yandex_iam_service_account" "sa" {
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
  name = "s-stage-account"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

```
Аналогичный файл будет и для `vpc-prod`, отличия будут только в имени создаваемой папки и имени сервисного аккаунта:

```
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  zone      = var.yc_region_a
}

resource "yandex_resourcemanager_folder" "folder1" {
  cloud_id    = var.yc_cloud_id
  name        = "diplom-prod"
  description = "Diploma workshop"
}

resource "yandex_iam_service_account" "sa" {
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
  name = "s-prod-account"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

```

3. Подготовим `backend` с использованием `Terraform Cloud`:

- Создадим в `Terraform Cloud` API токен
- Добавим созданный API токен в `/.terraformrc` для использования файла `backend.tf`

4. Создадим 2 папки пока с одинаковым содержимым:

![diplom_1_1.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_1_1.png)

5. В файлы `backend` для создания разных `workspaces` добавим содержимое:

```
#vpc-stage

terraform {

  backend "remote" {
    organization = "psvitov"

    workspaces {
      name = "vpc-stage"
    }
  }
}
```
```
#vpc-prod

terraform {

  backend "remote" {
    organization = "psvitov"

    workspaces {
      name = "vpc-prod"
    }
  }
}
```
Эти файлы при выполнении команды `terraform init` создадут `workspace`, каждый для своего рабочего пространства.

6. Протестируем работу созданных файлов командой `terraform init`:

Первоначальное состояние `Terraform Cloud`:

![diplom_1_2.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_1_2.png)

Выполнение команд:

![diplom_1_3.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_1_3.png)

Состояние `Terraform Cloud` после выполнения комманд:

![diplom_1_4.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_1_4.png)

7. Создадим файл `network.tf` для каждого `workspace` с описанием сети и подсетей в разных зонах доступности:

```
## network.tf

resource "yandex_vpc_network" "stage-net" {
  name = "stage-network"
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
}

resource "yandex_vpc_subnet" "stage-subnet-a" {
  v4_cidr_blocks = ["10.0.10.0/24"]
  zone           = var.yc_region_a
  name           = "stage-a"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.stage-net.id}"
}

resource "yandex_vpc_subnet" "stage-subnet-b" {
  v4_cidr_blocks = ["10.0.20.0/24"]
  zone           = var.yc_region_b
  name           = "stage-b"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.stage-net.id}"
}

resource "yandex_vpc_subnet" "stage-subnet-c" {
  v4_cidr_blocks = ["10.0.30.0/24"]
  zone           = var.yc_region_c
  name           = "stage-c"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.stage-net.id}"
}
```

```
## network.tf

resource "yandex_vpc_network" "prod-net" {
  name = "prod-network"
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
}

resource "yandex_vpc_subnet" "prod-subnet-a" {
  v4_cidr_blocks = ["10.1.10.0/24"]
  zone           = var.yc_region_a
  name           = "prod-a"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.prod-net.id}"
}

resource "yandex_vpc_subnet" "prod-subnet-b" {
  v4_cidr_blocks = ["10.1.20.0/24"]
  zone           = var.yc_region_b
  name           = "prod-b"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.prod-net.id}"
}

resource "yandex_vpc_subnet" "prod-subnet-c" {
  v4_cidr_blocks = ["10.1.30.0/24"]
  zone           = var.yc_region_c
  name           = "prod-c"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.prod-net.id}"
}
```

8. Создадим VPC с подсетями в разных зонах доступности

В папке `vpc-stage` создадим файл `vpc.tf` с содержимым:

```
resource "yandex_compute_instance_group" "stage-ig" {
  name               = "vpc-stage-ig"
  folder_id          = "${yandex_resourcemanager_folder.folder1.id}"
  service_account_id = "${yandex_iam_service_account.sa.id}"
  depends_on          = [yandex_resourcemanager_folder_iam_member.editor]
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd8jvcoeij6u9se84dt5"
      }
    }

    network_interface {
      network_id = "${yandex_vpc_network.stage-net.id}"
      subnet_ids = ["${yandex_vpc_subnet.stage-subnet-a.id}", "${yandex_vpc_subnet.stage-subnet-b.id}", "${yandex_vpc_subnet.stage-subnet-c.id}"]
      nat = "true"
    }

    metadata = {
      ssh-keys = "devops:ssh-rsa AAAAB3NzaC1yc2E*************************************HZlVbTVaFNOPIOVRgNc7mRRQ4+3CbJIwYTumH0pJal7Rc6CeTXFEb35HeMoO0eyEzan4TSOfXvS4Q5Wutq8CRAbbdG7UwrUGcMeK0U6XAQguuxVcY5C7bGJ8c2y2In19fM0TpheLA1c1LZeX2BXJbIXTJM52Fsfo0s0t6pXPDLXx/2PkdeFdrMhUybJ5202SQXfbsElgDsVCfaEkWMm8gJfsIzMqLWEHrheFtfcbLIRzpBvEs2OZbK6Fofo7akYy5zkjvOrGaVy4u9YoFStkD2uCGOp8D8q3ADULYEunI+INVTdg/JtBRjYBw60ZH devops@DevOps"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.yc_region_a, var.yc_region_b, var.yc_region_c]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion = 0
  }
}
```
Для создания одинаковых инстанстов можно использовать группы, при этом их можно расположить в одной или разных зонах доступности, в зависимости от поставленных задач.

Аналогичный файл создадим и в папке `vpc-prod`.

9. Проверим работу комманд `terraform plan`, `terraform apply`, `terraform destroy` в воркспейсе `vpc-stage`:

#### terraform plan

![diplom_1_5.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_1_5.png)

#### terraform apply

![diplom_1_6.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_1_6.png)

#### result terraform apply

![diplom_1_7.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_1_7.png)

#### terraform destroy

![diplom_1_8.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_1_8.png)

#### result terraform destroy

![diplom_1_9.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_1_9.png)

10. Для проверки работы `Terraform Cloud` создадим приватный репозиторий, поместим туда ранее созданные файлы, настроим `Terraform Cloud` на работу с созданным репозиторием и в каждом созданном `workspace` добавим путь до расположения наших файлов:

### Create repository

![diplom_1_10.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_1_10.png)

### Version Control vpc-prod

![diplom_1_11.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_1_11.png)

### Version Control vpc-stage

![diplom_1_12.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_1_12.png)

Проверим работу `Terraform Cloud` в воркспейсе `vpc-prod`:

### Primary state

![diplom_1_13.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_1_13.png)

### Plan finished

![diplom_1_14.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_1_14.png)

### Apply finished

![diplom_1_15.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_1_15.png)

Результат работы `Terraform Cloud` в `Яндекс.Облако`:

![diplom_1_16.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_1_16.png)

Удалить созданные ресурсы также можно через `Terraform Cloud`, выбрав в настройках `workspace` раздел `Destruction and Deletion` нажав на кнопку `Queue destroy plan`.

Cсылка на папку [terraform](https://github.com/psvitov/devops-netology/tree/main/Diplom/terraform) с содержимым файлов `.tf`


----

## 2 этап выполнения

### Создание Kubernetes кластера

<details>
   <summary><b>ЗАДАНИЕ</b></summary>

На этом этапе необходимо создать [Kubernetes](https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/) кластер на базе предварительно созданной инфраструктуры.   Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать региональный мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)
  
Ожидаемый результат:

1. Работоспособный Kubernetes кластер.
2. В файле `~/.kube/config` находятся данные для доступа к кластеру.
3. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.

</details>
   
---
### Решение
---

1. Для создания инфраструктуры за основу будем использовать файлы `terraform` 1 этапа.

![diplom_2_1.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_2_1.png)

2. Внесем правки в ранее созданные файлы - `backend.tf`, `network.tf`, `variables.tf`, :

```
## backend.tf

terraform {

  backend "remote" {
    organization = "psvitov"

    workspaces {
      name = "k8s-stage"
    }
  }
}
```

```
## network.tf

resource "yandex_vpc_network" "stage-net" {
  name = "stage-network"
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
}

resource "yandex_vpc_subnet" "stage-subnet-a" {
  v4_cidr_blocks = ["10.0.10.0/24"]
  zone           = var.yc_region_a
  name           = "stage-a"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.stage-net.id}"
}
```

```
## variables.tf

variable "yc_token" {
    description = "ID Yandex.Token"
    default = "y0_AgAAAAA********************2gMMEnMpiR9uptV4Qe44EV5sWrMw"
    sensitive = true
}

variable "yc_cloud_id" {
    description = "ID Yandex.Cloud"
    default = "b1g**********euurdt7"
    sensitive = true
}

variable "yc_region_a" {
    description = "Region Zone A"
    default = "ru-central1-a"
}
```

3. Создадим новый файл `meta.txt` для создания на развертываемой инфраструктуре необходимых пользователей и пробрасывания SSH ключей:

```
## meta.txt

#cloud-config
users:
  - name: au000846
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI*************************ogXK4AzEZEGT0VVZX17D/9LF127y au000846@terraform.ru-central1.internal
```

4. Вместо файла `vpc.tf` опишем необходимую для развертывания инфраструктуру в отдельных файлах

`master01.tf` - master-нода, где будет разворачиваться `Kuberspray`

`node01...node03` - worker-ноды для размещения подов

```
## master01.tf

resource "yandex_compute_instance" "master01" {
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
  name = "master01"
  zone = var.yc_region_a
  hostname = "master01.ru-central1.internal"

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
    subnet_id = "${yandex_vpc_subnet.stage-subnet-a.id}"
    nat = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

```

```
resource "yandex_compute_instance" "node01" {
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
  name = "node01"
  zone = var.yc_region_a
  hostname = "node01.ru-central1.internal"

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
```

5. Создадим папку `ansible`, файлы `inventory.tf` для создания файла инвентаризации для `Ansible` и файл `k8s.tf` для создания файла инвентаризации для `Kuberspray`:

```
## inventory.tf

resource "local_file" "inventory" {
  content = <<-DOC
    # Ansible inventory containing variable values from Terraform.
    # Generated by Terraform.
    [master]
    master01.ru-central1.internal ansible_host=${yandex_compute_instance.master01.network_interface.0.nat_ip_address}
 
    [nodes]
    node01.ru-central1.internal ansible_host=${yandex_compute_instance.node01.network_interface.0.nat_ip_address}
    node02.ru-central1.internal ansible_host=${yandex_compute_instance.node02.network_interface.0.nat_ip_address}
    node03.ru-central1.internal ansible_host=${yandex_compute_instance.node03.network_interface.0.nat_ip_address}
    DOC
  filename = "./ansible/inventory.ini"

  depends_on = [
    yandex_compute_instance.master01,
    yandex_compute_instance.node01,
    yandex_compute_instance.node02,
    yandex_compute_instance.node03
  ]
}
```

```
## k8s.tf

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
```

6. Создадим конфигурационный файл `ansible.cfg`:

```
[defaults]
inventory=./inventory
deprecation_warnings=False
command_warnings=False
ansible_port=22
host_key_checking = False
```

7. Создадим файл `kuberspray.yml` для конфигурирования  созданных серверов:

```
---
  - name: Setting master-node
    hosts: master
    become: yes
    tasks:

      - name: Swapoff
        ansible.builtin.command: swapoff -a

      - name: Create SSH key
        become_user: root
        user:
          name: root
          generate_ssh_key: yes
          ssh_key_bits: 2048
          ssh_key_file: .ssh/id_rsa

      - name: Read key file
        become_user: root
        shell: cat ~/.ssh/id_rsa.pub
        register: key_content

      - name: Add authorized_keys
        become_user: root
        lineinfile:
          path: "~/.ssh/authorized_keys"
          line: "{{ key_content.stdout }}"

      - name: Copy authorized_keys
        become_user: root
        ansible.builtin.fetch:
          src: ~/.ssh/authorized_keys
          dest: ./ansible/tmp/
          flat: yes

      - name: Install EPEL
        ansible.builtin.yum:
          name: epel-release
          state: latest

      - name: Upgrade all packages
        ansible.builtin.yum:
          name: '*'
          state: latest

      - name: Install packages
        ansible.builtin.yum:
          name:
            - python36
            - git
          state: present

      - name: Install and upgrade pip
        pip:
          name: pip
          extra_args: --upgrade
          executable: pip3

      - name: Download repo Kuberspray
        become_user: root
        ansible.builtin.git:
          repo: 'https://github.com/kubernetes-sigs/kubespray.git'
          dest: /root/kuberspray
          version: release-2.20

      - name: Istall requests
        ansible.builtin.pip:
          name: requests==2.23.0
          executable: pip3

      - name: Istall requirements        
        ansible.builtin.pip:
          requirements: /root/kuberspray/requirements-2.11.txt
          executable: pip3

      - name: Add usr/local/bin in $PATH
        become_user: root
        lineinfile:
          path: "~/.bashrc"
          line: "export PATH=$PATH:/usr/local/bin"

      - name: Create a directory
        become_user: root
        ansible.builtin.file:
          path: ~/k8s
          state: directory
          mode: '0755'

      - name: Copy config Kuberspray
        become_user: root
        ansible.builtin.command:
          cmd: cp -R ~/kuberspray/inventory/sample ~/k8s

      - name: Copy k8s.ini
        become_user: root
        ansible.builtin.copy:
          src: ./ansible/k8s.ini
          dest: ~/k8s/sample

      - name: Rename cluster name
        become_user: root
        replace:
          path: "~/k8s/sample/group_vars/k8s_cluster/k8s-cluster.yml"
          regexp: '^cluster_name: cluster.local$'
          replace: 'cluster_name: k8s.local'


  - name: Settings worker nodes
    hosts: nodes
    become: yes
    tasks:

      - name: Swapoff
        ansible.builtin.command: swapoff -a

      - name: Copy authorized_keys
        become_user: root
        ansible.builtin.copy:
          src: ./ansible/tmp/authorized_keys
          dest: ~/.ssh/

```

Описание конфигурационного файла:

Действия на master-ноде:
- Отключение свопа
- Создание SSH ключа, копирование его в `authorized_keys`
- Установка репозитория EPEL и базовое обновление сиситемы
- Установка `Python 3.6`, `Git`
- Обновление `pip3`
- Скачивание репозитория `Kuberspray`, установка всех зависимостей для разворачивания
- Добавление папки `/usr/local/bin` в переменную окружения `$PATH`
- Создание директории и копирование инвентарного файла
- Переименование кластера

Действия на worker-нодах:
- Отключение свопа
- Копирование SSH ключа master-ноды в `authorized_keys`

8. Для запуска `ansible` через `terraform` создадим файл `ansible.tf`:

```
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
```

9. В итоге получается список файлов:

![diplom_2_2.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_2_2.png)

10. Запускаем последовательно комманды `terraform init`, `terraform plan` и `terraform apply`:

Результат работы:
![diplom_2_3.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_2_3.png)

11. Проверяем созданную инфраструктуру в ЯО:

---
![diplom_2_4.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_2_4.png)
---
![diplom_2_5.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_2_5.png)
---

11. Подключаемся к master-ноде и проверяем работу `ansible`:

![diplom_2_6.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_2_6.png)

12. Запускаем на master-ноде создание кластера `Kubernetes` через `Kuberspray`:

```
ansible-playbook ~/kuberspray/cluster.yml -i ~/k8s/sample/k8s.ini --diff
```

13. Результат работы:

---
![diplom_2_7.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_2_7.png)
---
![diplom_2_8.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_2_8.png)
---
![diplom_2_9.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_2_9.png)
---


Cсылка на папку [k8s](https://github.com/psvitov/devops-netology/tree/main/Diplom/k8s)

----
## 3 этап выполнения

### Создание тестового приложения

<details>
   <summary><b>ЗАДАНИЕ</b></summary>

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистр с собранным docker image. В качестве регистра может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.

</details>

---
### Решение
---

1. Создадим отдельный репозиторий, в который поместим конфиг [`nginx`](https://github.com/psvitov/nginx/blob/main/default) и файлы для статического веб-сайта:

---
![diplom_3_1.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_3_1.png)
---

2. Создадим [`Dockerfile`](https://github.com/psvitov/nginx/blob/main/Dockerfile) с содержимым:

```
FROM centos:7
RUN yum install epel-release -y
RUN yum install nginx -y
CMD systemctl start nginx
CMD systemctl enable nginx
RUN mkdir -p /var/www/html/default/images
COPY index.html /var/www/html/default/
COPY red.png /var/www/html/default/images/
COPY blue.jpg /var/www/html/default/images/
COPY default /etc/nginx/sites-available/
CMD systemctl restart nginx
```

3. Создадим образ `nginx-stage` с помощью команды `docker build . -t nginx-stage`:

---
![diplom_3_2.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_3_2.png)
---

4. Проверим созданный образ:

---
![diplom_3_3.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_3_3.png)
---
![diplom_3_4.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_3_4.png)
---

5. Загрузим созданный образ в `Docker Hub`:

---
![diplom_3_5.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_3_5.png)
---

Ссылка на загруженный образ в `Docker Hub`: [psvitov/nginx-stage](https://hub.docker.com/repository/docker/psvitov/nginx-stage/general)

Ссылка на репозиторий [`nginx`](https://github.com/psvitov/nginx)


----

## 4 этап выполнения

### Подготовка cистемы мониторинга и деплой приложения

<details>
   <summary><b>ЗАДАНИЕ</b></summary>

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Рекомендуемый способ выполнения:
1. Воспользовать пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). При желании можете собрать все эти приложения отдельно.
2. Для организации конфигурации использовать [qbec](https://qbec.io/), основанный на [jsonnet](https://jsonnet.org/). Обратите внимание на имеющиеся функции для интеграции helm конфигов и [helm charts](https://helm.sh/)
3. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте в кластер [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры.

Альтернативный вариант:
1. Для организации конфигурации можно использовать [helm charts](https://helm.sh/)

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ к тестовому приложению.

</details>   
   
---
### Решение
---

1. Скачаем репозиторий `kube-prometeus release-0.11`:

![diplom_4_1.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_4_1.png)

Так как нам необходимо организовать HTTP-доступ к web интерфейсу `Grafana`, перед установкой `kube-prometeus` изменим настройки сервиса `Grafana` и настройки сети `Grafana`:

Изменим в `grafana-service.yaml` тип сетевого сервиса с `ClusterIP` на `NodePort` и укажем конкретный порт из диапазона 30000-32767

```
## grafana-service.yaml

apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/component: grafana
    app.kubernetes.io/name: grafana
    app.kubernetes.io/part-of: kube-prometheus
    app.kubernetes.io/version: 9.3.2
  name: grafana
  namespace: monitoring
spec:
  ports:
  - name: http
    port: 3000
    targetPort: http
    nodePort: 30003
  type: NodePort
  selector:
    app.kubernetes.io/component: grafana
    app.kubernetes.io/name: grafana
    app.kubernetes.io/part-of: kube-prometheus
```

Ссылка на измененый [grafana-service.yaml](https://github.com/psvitov/devops-netology/blob/main/Diplom/kube-prometheus/grafana-service.yaml)

Отключим в `grafana-networkPolicy.yaml` настройки ingress:

```
## grafana-networkPolicy.yaml

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  labels:
    app.kubernetes.io/component: grafana
    app.kubernetes.io/name: grafana
    app.kubernetes.io/part-of: kube-prometheus
    app.kubernetes.io/version: 9.3.2
  name: grafana
  namespace: monitoring
spec:
  egress:
  - {}
  ingress:
  - {}
#  - from:
#    - podSelector:
#        matchLabels:
#          app.kubernetes.io/name: prometheus
#    ports:
#    - port: 3000
#      protocol: TCP
  podSelector:
    matchLabels:
      app.kubernetes.io/component: grafana
      app.kubernetes.io/name: grafana
      app.kubernetes.io/part-of: kube-prometheus
  policyTypes:
  - Egress
  - Ingress
```

Ссылка на измененый [grafana-networkPolicy.yaml](https://github.com/psvitov/devops-netology/blob/main/Diplom/kube-prometheus/grafana-networkPolicy.yaml)


2. Создадим пространство имен и `CRD`:

---
![diplom_4_2.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_4_2.png)
---
![diplom_4_3.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_4_3.png)
---

3. Проверяем созданные ресурсы:

![diplom_4_4.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_4_4.png)


4. Проверяем работу сервса `Grafana`:


![diplom_4_5.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_4_5.png)

5. Для деплоя тестового приложения, созданного на 3-м этапе используем `Qbec`

Добавим в первоначальный манифест `Ansible`, который использовали для предварительной настройки ВМ кластера установку Qbec.

```
  - name: Install Qbec
    hosts: master
    become: yes
    tasks:

      - name: Create a directory golang
        become_user: root
        ansible.builtin.file:
          path: ~/golang
          state: directory
          mode: '0755'

      - name: Create a directory qbec
        become_user: root
        ansible.builtin.file:
          path: ~/qbec
          state: directory
          mode: '0755'

      - name: Download Golang
        ansible.builtin.get_url:
          url: https://go.dev/dl/go1.19.7.linux-amd64.tar.gz
          dest: /root/golang/go1.19.7.linux-amd64.tar.gz

      - name: Download Qbec
        ansible.builtin.get_url:
          url: https://github.com/splunk/qbec/releases/download/v0.15.2/qbec-linux-amd64.tar.gz
          dest: /root/qbec/qbec-linux-amd64.tar.gz

      - name: Extract Golang
        ansible.builtin.unarchive:
          src: /root/golang/go1.19.7.linux-amd64.tar.gz
          dest: /usr/local
          remote_src: yes

      - name: Extract Qbec
        ansible.builtin.unarchive:
          src: /root/qbec/qbec-linux-amd64.tar.gz
          dest: /usr/local/bin
          remote_src: yes

      - name: Add usr/local/go/bin in $PATH
        become_user: root
        lineinfile:
          path: "~/.bashrc"
          line: "export PATH=$PATH:/usr/local/go/bin"
```

Применяем измененный манифест и проверяем установку необходимого ПО:

![diplom_4_6.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_4_6.png)

Предварительный вариант файла [`kuberspray.yml](https://github.com/psvitov/devops-netology/blob/main/Diplom/kube-prometheus/kuberspray.yml)

6. Создадим конфигурацию `qbec-stage`:

![diplom_4_7.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_4_7.png)

7. Cоздадим 2 окружения: `stage` с явным указанием параметров в файле и `prod` с подключением файла `prod.libsonnet`

```
## stage.jsonnet

local prefix = 'stage';

[
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: 'diplom-' + prefix,
    },
    spec: {
      replicas: 3,
      selector: {
        matchLabels: {
          app: 'app-' + prefix,
          tier: prefix
        },
      },
      template: {
        metadata: {
          labels: {
            app: 'app-' + prefix,
            tier: prefix
          },
        },
        spec: {
          containers: [
            {
              name: 'front-' + prefix,
              image: 'hub.docker.com/r/psvitov/nginx-stage:latest',
              imagePullPolicy: 'Always',
            },
          ],
        },
      },
    },
  },
]
```
---

```
## prod.jsonnet

local p = import '../params.libsonnet';
local params = p.components.prod;
local prefix = 'prod';

[
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: 'diplom-' + prefix,
    },
    spec: {
      replicas: params.replicas,
      selector: {
        matchLabels: {
          app: 'app-' + prefix,
          tier: prefix
        },
      },
      template: {
        metadata: {
          labels: {
            app: 'app-' + prefix,
            tier: prefix
          },
        },
        spec: {
          containers: [
            {
              name: 'front-' + prefix,
              image: params.image,
              imagePullPolicy: 'Always',
            },
          ],
        },
      },
    },
  },
]
```
---

```
## prod.libsonnet

// this file has the baseline default parameters
{
  components: {
    prod: {
      replicas: 3,
      image: 'hub.docker.com/r/psvitov/nginx-stage:latest',
    },
  },
}
```

Создадим 2 `namespace` в кластере `Kubernetes`:

![diplom_4_8.png](https://github.com/psvitov/devops-netology/blob/main/Diplom/diplom_4_8.png)

Изменим файл `qbec.yaml` добавим созданные ранее `namespace`:

```
## qbec.yaml

apiVersion: qbec.io/v1alpha1
kind: App
metadata:
  name: qbec-stage
spec:
  environments:
    qbec:
      defaultNamespace: qbec
      server: https://127.0.0.1:6443
  vars: {}
```

8. Проверим созданные файлы на валидацию и развернем окружение:









----

## 5 этап выполнения

### Установка и настройка CI/CD

<details>
   <summary><b>ЗАДАНИЕ</b></summary>

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/) либо [gitlab ci](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/)

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистр, а также деплой соответствующего Docker образа в кластер Kubernetes.

</details>   

---
### Решение
---










----

## Что необходимо для сдачи задания?

1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.
2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud.
3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.
4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.
5. Репозиторий с конфигурацией Kubernetes кластера.
6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.
7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)
