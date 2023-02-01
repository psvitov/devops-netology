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
6. Создадим сеть и публичную подсеть:

```
resource "yandex_vpc_network" "cloud-net" {
  name = "cloudnetwork"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
}

resource "yandex_vpc_subnet" "cloud-subnet" {
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = var.yc_region
  name           = "public"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.cloud-net.id}"
}
```










