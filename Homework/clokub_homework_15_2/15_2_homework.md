# Домашнее задание к занятию 15.2 "Вычислительные мощности. Балансировщики нагрузки".
Домашнее задание будет состоять из обязательной части, которую необходимо выполнить на провайдере Яндекс.Облако, и дополнительной части в AWS (можно выполнить по желанию). Все домашние задания в 15 блоке связаны друг с другом и в конце представляют пример законченной инфраструктуры.
Все задания требуется выполнить с помощью Terraform, результатом выполненного домашнего задания будет код в репозитории. Перед началом работ следует настроить доступ до облачных ресурсов из Terraform, используя материалы прошлых лекций и ДЗ.

---
## Задание 1. Яндекс.Облако (обязательное к выполнению)

1. Создать bucket Object Storage и разместить там файл с картинкой:
- Создать bucket в Object Storage с произвольным именем (например, _имя_студента_дата_);
- Положить в bucket файл с картинкой;
- Сделать файл доступным из Интернет.
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и web-страничкой, содержащей ссылку на картинку из bucket:
- Создать Instance Group с 3 ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`;
- Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata);
- Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из bucket;
- Настроить проверку состояния ВМ.
3. Подключить группу к сетевому балансировщику:
- Создать сетевой балансировщик;
- Проверить работоспособность, удалив одну или несколько ВМ.
4. *Создать Application Load Balancer с использованием Instance group и проверкой состояния.

Документация
- [Compute instance group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group)
- [Network Load Balancer](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer)
- [Группа ВМ с сетевым балансировщиком](https://cloud.yandex.ru/docs/compute/operations/instance-groups/create-with-balancer)

---
### Ответ:
---

1. Возьмем за основу домашнее задание лекции "Организация сети"
2. Для определения переменных создадим файл `variables.tf` с содержимым:

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

3. Заранее определим зону `ru-central1-a` в файле `variables.tf`
4. В файле `/.terraformrc` укажем источник, из которого будет устанавливаться провайдер:

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

5. Создадим основной конфигурационный файл `main.tf`, добавим начальное содержимое:

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
6. Создадим пустой каталог (VPC):

```
resource "yandex_resourcemanager_folder" "folder1" {
  cloud_id    = var.yc_cloud_id
  name        = "loadbalancer"
  description = "Load Balancer"
}
```

7. Создадим сервисный аккаунт с ролью `editor`:

```
resource "yandex_iam_service_account" "sa" {
  name = "s-account"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}
```
8. Создадим статический ключ доступа и бакет, с использованием этого статического ключа:

```
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

resource "yandex_storage_bucket" "bucket-loadb" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "psvitov-100223"
}
```

9. Создадим скриншот созданной папки и поместим его в бакет:

![15_2_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_15_2/15_2_1.png)

```
resource "yandex_storage_object" "foto-object" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "psvitov-100223"
  key        = "foto"
  source     = "~/Homeworks/15_2/15_2_1.png"
}
```

10. Ссылку на загруженный в бакет файл можно получить в консоли управления ЯО. К сожалению не нашел как это реализовать в `terraform` ЯО, можно реализовать в `AWS CLI` согласно статьи [Подписанные URL](https://cloud.yandex.ru/docs/storage/concepts/pre-signed-urls#composing-string-to-sign)

11. Создадим сеть и подсеть:

```
resource "yandex_vpc_network" "lb-net" {
  name = "balance-network"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
}

resource "yandex_vpc_subnet" "cloud-subnet" {
  v4_cidr_blocks = ["10.0.0.0/24"]
  zone           = var.yc_region
  name           = "public"
  folder_id      = "${yandex_resourcemanager_folder.folder1.id}"
  network_id     = "${yandex_vpc_network.lb-net.id}"
}
```

12. Создадим группу из 3-х ВМ на основе образа `LAMP`: 

```
resource "yandex_compute_instance_group" "i-group" {
  name               = "ig-balancer"
  folder_id          = "${yandex_resourcemanager_folder.folder1.id}"
  service_account_id = "${yandex_iam_service_account.sa.id}"
  instance_template {
    platform_id = "standard-v3"
    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd8vfsrqdf7gdrf378vk"
      }
    }

    network_interface {
      network_id = "${yandex_vpc_network.lb-net.id}"
      subnet_ids = ["${yandex_vpc_subnet.lb-subnet.id}"]
      nat = "true"
    }

    metadata = {
      user-data = "${file("meta.txt")}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = var.yc_region
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }
}
```

Загрузку файла стартовой страницы `index.html` будем производить через агента `cloud-init` путем добавления пользовательских метаданных в файл `meta.txt`:

```
#cloud-config
users:
  - name: devops
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3Nza********************4BpA5AR6cKFDJ9uznV6ZmvLH3Z+3H0o9NHH4iIs devops@DevOps
runcmd:
  - sudo chown -R devops:www-data /var/www/html
write_files:
  - owner: devops:www-data
    path: /var/www/html/index.html
    content: |
      <html>
        <head>
          <title>Netology DevOps</title>
        </head>
        <body>
          <a href="https://storage.yandexcloud.net/psvitov-090223/foto?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=YCAJEr6X8-08IA63jR>
        </body>
      </html>
runcmd:
  - sudo service apache2 restart
```

13. Создадим целевую группу для балансировщика и добавим в группе при создании ВМ добавление в целевую группу:

```
resource "yandex_lb_target_group" "tg" {
  name      = "target-group"
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
}
```

```
  load_balancer {
    target_group_name        = "${yandex_lb_target_group.tg.id}"
  }
```

14. Добавим сетевой балансировщик:

```
resource "yandex_lb_network_load_balancer" "lb" {
  name = "my-network-load-balancer"
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"

  listener {
    name = "my-listener"
    port = 8080
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = "${yandex_lb_target_group.tg.id}"

    healthcheck {
      name = "http"
      http_options {
        port = 80
      }
    }
  }
}
```

15. Проверяем созданные ресурсы и балансировщик:

![15_2_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_15_2/15_2_2.png)
![15_2_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_15_2/15_2_3.png)

16. Проверяем работу балансировщика:

![15_2_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_15_2/15_2_4.png)

17. Отключаем две ВМ и проверяем работу балансировщика:

![15_2_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_15_2/15_2_5.png)
![15_2_6.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_15_2/15_2_6.png)
![15_2_7.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_15_2/15_2_7.png)


Итоговый файл [main.tf](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_15_2/main.tf)

