# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."

## Задача 1 (Вариант с Yandex.Cloud). 

1. Подробная инструкция на русском языке содержится [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
2. Обратите внимание на период бесплатного использования после регистрации аккаунта. 
3. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки
базового терраформ конфига.
4. Воспользуйтесь [инструкцией](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs) на сайте терраформа, что бы 
не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

---
### Ответ:
---

1. Регистрация в Yandex.Cloud была проведена в апреле, ЯО использовалось в одном из ДЗ.

![7_2_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_7_2/7_2_1.png)

2. создаем файл `variables.tf` для определения переменных:

> 
    variable "yc_token" {
        description = "OAuth-token Yandex.Cloud"
        default = "AQAAAA*****EAATuwQ3i5zgf2kUokcys-7P6_1k"
    }
    
    variable "yc_cloud_id" {
        description = "ID Yandex.Cloud"
        default = "b1g8fhcp9qm*****rdt7"
    }
    
    variable "yc_folder_id" {
        description = "ID folder terraform"
        default = "b1g9ofom2nt*****hnlh"
    }
    
    variable "yc_region" {
        description = "Region Zone"
        default = "ru-central1-a"
    }

![7_2_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_7_2/7_2_3.png)


## Задача 2. Создание aws ec2 или yandex_compute_instance через терраформ. 

1. В каталоге `terraform` вашего основного репозитория, который был создан в начале курсе, создайте файл `main.tf` и `versions.tf`.
2. Зарегистрируйте провайдер 
   1. для [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs). В файл `main.tf` добавьте
   блок `provider`, а в `versions.tf` блок `terraform` с вложенным блоком `required_providers`. Укажите любой выбранный вами регион 
   внутри блока `provider`.
   2. либо для [yandex.cloud](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs). Подробную инструкцию можно найти 
   [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
3. Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунту. Поэтому в предыдущем задании мы указывали
их в виде переменных окружения. 
4. В файле `main.tf` воспользуйтесь блоком `data "aws_ami` для поиска ami образа последнего Ubuntu.  
5. В файле `main.tf` создайте рессурс 
   1. либо [ec2 instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance).
   Постарайтесь указать как можно больше параметров для его определения. Минимальный набор параметров указан в первом блоке 
   `Example Usage`, но желательно, указать большее количество параметров.
   2. либо [yandex_compute_image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_image).
6. Также в случае использования aws:
   1. Добавьте data-блоки `aws_caller_identity` и `aws_region`.
   2. В файл `outputs.tf` поместить блоки `output` с данными об используемых в данный момент: 
       * AWS account ID,
       * AWS user ID,
       * AWS регион, который используется в данный момент, 
       * Приватный IP ec2 инстансы,
       * Идентификатор подсети в которой создан инстанс.  
7. Если вы выполнили первый пункт, то добейтесь того, что бы команда `terraform plan` выполнялась без ошибок. 


В качестве результата задания предоставьте:
1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
1. Ссылку на репозиторий с исходной конфигурацией терраформа.  
 
---
### Ответ:
---

1. Создание файлов `main.tf` и `versions.tf`:

> 
    root@DevOps://root/Homeworks/hw72/terraform# ls -l
    итого 12
    -rw------- 1 root root 2402 июл  7 20:06 key.json
    -rw-r--r-- 1 root root  863 июл  7 21:33 main.tf
    -rw-r--r-- 1 root root  412 июл  7 21:16 variables.tf
    -rw-r--r-- 1 root root    0 июл  7 20:24 versions.tf

2. Регистрация провайдера:

> 
    root@DevOps://root/Homeworks/hw72/terraform# cat ~/.terraformrc
    provider_installation {
      network_mirror {
        url = "https://terraform-mirror.yandexcloud.net/"
        include = ["registry.terraform.io/*/*"]
      }
      direct {
        exclude = ["registry.terraform.io/*/*"]
      }
    }

    root@DevOps://root/Homeworks/hw72/terraform#
    
3. В файле `main.tf` создаем ресурс:

> 
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
      folder_id = var.yc_folder_id
      zone      = var.yc_region
    }

    data "yandex_compute_image" "image" {
      family = "centos-7"
    }

    resource "yandex_compute_instance" "vm" {
      name        = "centos_7_test"
      platform_id = "standard-v1"
      zone        = var.yc_region
      folder_id = var.yc_folder_id

      resources {
          cores  = 2
          memory = 4
        }
    boot_disk {
        initialize_params {
          image_id = "image_id"
          type = "network-hdd"
          size = "40"
          }
        }
      network_interface {
        subnet_id = "subnet1"
        nat       = "false"
        }

        metadata = {
          ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
        }
    }

[Файл main.tf](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_7_2/main.tf)

5.
6.
7.
8. Результат выполнения `terraform plan`:

> 
    root@DevOps://root/Homeworks/hw72/terraform# terraform plan
    data.yandex_compute_image.image: Reading...
    data.yandex_compute_image.image: Read complete after 2s [id=fd88d14a6790do254kj7]

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
    with the following symbols:
      + create

    Terraform will perform the following actions:

      # yandex_compute_instance.vm will be created
      + resource "yandex_compute_instance" "vm" {
          + created_at                = (known after apply)
          + folder_id                 = "b1g9ofom2ntbfc8shnlh"
          + fqdn                      = (known after apply)
          + hostname                  = (known after apply)
          + id                        = (known after apply)
          + metadata                  = {
              + "ssh-keys" = <<-EOT
                    centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCkGrgH7wiBVjDd7jNHihtG+lwBqLZXOAPirf1QqO4BrmklardHiVZ+ifVucS7CKPxV4/ak7qU5DrNw2YfCIVjE/NuCSI9rWp19BKK276wrcUQBYOCzEsHuzEA307aP8n2qj3CHcePoVbOwMuKhIBORzVKXj84n5MVoqElnWdYppONhn5yJ3huudQnX8SrVhkqeqfQKEegKPZX8EoMNTh5l2cJZoIW4s3z+2JfedCVFbbGPxjJQH8/Ptb93m0wp5K+o8/DMZCB6EZGooEGevyqDVdReDHkR7i5igwGMOA7LQuUo5Z9eoIBBG58UDdXvKcFFvHVcoRIguWGlwQa7fkHF root@DevOps
                EOT
            }
          + name                      = "centos_7_test"
          + network_acceleration_type = "standard"
          + platform_id               = "standard-v1"
          + service_account_id        = (known after apply)
          + status                    = (known after apply)
          + zone                      = "ru-central1-a"

          + boot_disk {
              + auto_delete = true
              + device_name = (known after apply)
              + disk_id     = (known after apply)
              + mode        = (known after apply)

              + initialize_params {
                  + description = (known after apply)
                  + image_id    = "image_id"
                  + name        = (known after apply)
                  + size        = 40
                  + snapshot_id = (known after apply)
                  + type        = "network-hdd"
                }
            }

          + network_interface {
              + index              = (known after apply)
              + ip_address         = (known after apply)
              + ipv4               = true
              + ipv6               = (known after apply)
              + ipv6_address       = (known after apply)
              + mac_address        = (known after apply)
              + nat                = false
              + nat_ip_address     = (known after apply)
              + nat_ip_version     = (known after apply)
              + security_group_ids = (known after apply)
              + subnet_id          = "subnet1"
            }

          + placement_policy {
              + placement_group_id = (known after apply)
            }

          + resources {
              + core_fraction = 100
              + cores         = 2
              + memory        = 4
            }

          + scheduling_policy {
              + preemptible = (known after apply)
            }
        }

    Plan: 1 to add, 0 to change, 0 to destroy.

    ──────────────────────────────────────────────────────────────────────────────────────────────────────────────

    Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these
    actions if you run "terraform apply" now.

