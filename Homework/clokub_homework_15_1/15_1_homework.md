# Домашнее задание к занятию "15.1. Организация сети"

Домашнее задание будет состоять из обязательной части, которую необходимо выполнить на провайдере Яндекс.Облако и дополнительной части в AWS по желанию. Все домашние задания в 15 блоке связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
Все задания требуется выполнить с помощью Terraform, результатом выполненного домашнего задания будет код в репозитории. 

Перед началом работ следует настроить доступ до облачных ресурсов из Terraform используя материалы прошлых лекций и [ДЗ](https://github.com/netology-code/virt-homeworks/tree/master/07-terraform-02-syntax ). А также заранее выбрать регион (в случае AWS) и зону.

---
## Задание 1. Яндекс.Облако (обязательное к выполнению)

1. Создать VPC.
- Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.
- Создать в vpc subnet с названием public, сетью 192.168.10.0/24.
- Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1
- Создать в этой публичной подсети виртуалку с публичным IP и подключиться к ней, убедиться что есть доступ к интернету.
3. Приватная подсеть.
- Создать в vpc subnet с названием private, сетью 192.168.20.0/24.
- Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс
- Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее и убедиться что есть доступ к интернету

Resource terraform для ЯО
- [VPC subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet)
- [Route table](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table)
- [Compute Instance](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance)

---
### Ответ:
---

1. Для определения переменных создадим файл `variables.tf` с содержимым:

```
variable "yc_token" {
    description = "OAuth-token Yandex.Cloud"
    default = "AQAAAAAARMfE********************-7P6_1k"
}

variable "yc_cloud_id" {
    description = "ID Yandex.Cloud"
    default = "b1g************t7"
}

variable "yc_region" {
    description = "Region Zone"
    default = "ru-central1-a"
}
```

2. Заранее определим зону `ru-central1-a` в файле `variables.tf`
3. В файле `/.terraformrc` укажем источник, из которого будет устанавливаться провайдер:

```
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```

4. Создадим основной конфигурационный файл `main.tf`, добавим начальное содержимое:

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
  zone      = var.yc_region
}
```
5. Создадим пустой каталог (VPC):

```
resource "yandex_resourcemanager_folder" "folder1" {
  cloud_id    = var.yc_cloud_id
  name        = "cloud-network"
  description = "Cloud Networks"
}
```
6. Создадим  2 сети и 2 подсети:

```
resource "yandex_vpc_network" "cloud-net" {
  name = "cloudnetwork"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
}

resource "yandex_vpc_network" "private-net" {
  name = "privatenetwork"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
}

resource "yandex_vpc_subnet" "cloud-subnet" {
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = var.yc_region
  name           = "public"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.cloud-net.id}"
}

resource "yandex_vpc_subnet" "private-subnet" {
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = var.yc_region
  name           = "private"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.private-net.id}"
```
Причина создания 2-х сетей и 2-х подсетей по одной в каждой из них: ЯО не работает с маршрутизацией в рамках одной сети:

"В настоящее время нельзя использовать префиксы из диапазонов адресов, выделенных для подсетей внутри виртуальной сети. Поддерживаются только префиксы назначения вне виртуальной сети, например, префиксы подсетей другой сети Yandex Cloud или вашей локальной сети."

[Статическая маршрутизация](https://cloud.yandex.ru/docs/vpc/concepts/static-routes)


7. Создадим ВМ `NAT-instance`:

```
resource "yandex_compute_instance" "nat" {
  name        = "nat-instance"
  platform_id = "standard-v1"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  zone        = var.yc_region

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8o8aph4t4pdisf1fio"
      type = "network-hdd"
      size = "10"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.cloud-subnet.id}"
    ip_address = "192.168.10.254"
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.private-subnet.id}"
    ip_address = "192.168.20.254"
  }
}
```

8. Создадим в публичной подсети ВМ с публичным IP:

```
resource "yandex_compute_instance" "public-vm" {
  name        = "public-vm1"
  platform_id = "standard-v1"
  folder_id   = "${yandex_resourcemanager_folder.folder1.id}"
  zone        = var.yc_region

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8jvcoeij6u9se84dt5"
      type = "network-hdd"
      size = "20"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.cloud-subnet.id}"
    nat = "true"
  }

  metadata = {
    user-data = "${file("~/15_1/meta.txt")}"
  }
}
```

9. Создаем `route table`:

```
resource "yandex_vpc_route_table" "route-table" {
  name = "route-private"
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
  network_id = "${yandex_vpc_network.cloud-net.id}"

  static_route {
    destination_prefix = "192.168.20.0/24"
    next_hop_address   = "192.168.10.254"
  }
}
```

10. Создадим в приватной подсети ВМ с внутренним IP:

```
resource "yandex_compute_instance" "private-vm" {
  name        = "private-vm1"
  platform_id = "standard-v1"
  folder_id   = "${yandex_resourcemanager_folder.folder1.id}"
  zone        = var.yc_region

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8jvcoeij6u9se84dt5"
      type = "network-hdd"
      size = "20"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.private-subnet.id}"
    nat = "false"
  }
}
```
Итоговый файл [main.tf](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_15_1/main.tf)


11. После запуска команд `terraform init`, `terraform validate`, `terraform plan`, `terraform apply` получаем необходимые ресурсы:

![15_1_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_15_1/15_1_1.png)

12. Подключаемся к публичной ВМ и проверяем интернет:

![15_1_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_15_1/15_1_2.png)

13. Проверка работы интернета на приватной ВМ неудачна, вероятнее всего связано в некорректной работой таблицы маршрутизации, хотя публичная ВМ пингует и приватную ВМ и NAT-инстанс:

![15_1_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_15_1/15_1_3.png)






