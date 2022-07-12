# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws. 

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано 
[здесь](https://www.terraform.io/docs/backends/types/s3.html).
1. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше. 

---
### Ответ:
---

#### Cоздание backend в Yandex.Cloud

1. Создаем бакет:

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

       resource "yandex_storage_bucket" "test" {
         access_key = "YCAJE*****PTm97SIzOSc09d7"
         secret_key = "YCOP0*****knigY7qvIf4JZA2I8GN7lOOC-oaky5"
         bucket = "psvitovbucketopp152"
       }

[Ссылка 1](https://cloud.yandex.ru/docs/iam/operations/sa/create-access-key)

2. Настраиваем backend:

>
    terraform {
      required_providers {
        yandex = {
          source = "yandex-cloud/yandex"
          version = "0.61.0"
        }
      }
      required_version = ">= 0.13"

      backend "s3" {
          endpoint   = "storage.yandexcloud.net"
          bucket     = "psvitovbucketopp152"
          region     = "ru-central1"
          key        = "terraform.tfstate"
          access_key = "YCAJE*****PTm97SIzOSc09d7"
          secret_key = "YCOP0*****knigY7qvIf4JZA2I8GN7lOOC-oaky5"

          skip_region_validation      = true
          skip_credentials_validation = true
        }

    }

    provider "yandex" {
      token     = var.yc_token
      cloud_id  = var.yc_cloud_id
      folder_id = var.yc_folder_id
      zone      = var.yc_region
    }

[Ссыллка 2](https://cloud.yandex.ru/docs/storage/operations/buckets/create)

Результат выполнения команды `terraform init -reconfigure`

![7_3_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_7_3/7_3_1.png)


## Задача 2. Инициализируем проект и создаем воркспейсы. 

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице 
dynamodb.
    * иначе будет создан локальный файл со стейтами.  
1. Создайте два воркспейса `stage` и `prod`.
1. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
использовались разные `instance_type`.
1. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два. 
1. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
1. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
1. При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:
* Вывод команды `terraform workspace list`.
* Вывод команды `terraform plan` для воркспейса `prod`.  

---
### Ответ:
---

1. Выполняем `terraform init`:

>
       root@DevOps:~/Homeworks/hw73/terraform# terraform init

       Initializing the backend...

       Initializing provider plugins...
       - Reusing previous version of yandex-cloud/yandex from the dependency lock file
       - Using previously-installed yandex-cloud/yandex v0.61.0

       Terraform has been successfully initialized!

       You may now begin working with Terraform. Try running "terraform plan" to see
       any changes that are required for your infrastructure. All Terraform commands
       should now work.

       If you ever set or change modules or backend configuration for Terraform,
       rerun this command to reinitialize your working directory. If you forget, other
       commands will detect it and remind you to do so if necessary.

2. Создаем `stage`:

>
       root@DevOps:~/Homeworks/hw73/terraform# terraform workspace new stage
       Created and switched to workspace "stage"!

       You're now on a new, empty workspace. Workspaces isolate their state,
       so if you run "terraform plan" Terraform will not see any existing state
       for this configuration.

2. Создаем `prod`:

>
       root@DevOps:~/Homeworks/hw73/terraform# terraform workspace new prod
       Created and switched to workspace "prod"!

       You're now on a new, empty workspace. Workspaces isolate their state,
       so if you run "terraform plan" Terraform will not see any existing state
       for this configuration.

3. Выводим список `workspase`:

>
       root@DevOps:~/Homeworks/hw73/terraform# terraform workspace list
         default
       * prod
         stage
         
4. Вывод `terraform plan`:

>
       root@DevOps:~/Homeworks/hw73/terraform# terraform plan
       data.yandex_compute_image.image: Reading...
       data.yandex_compute_image.image: Read complete after 2s [id=fd88d14a6790do254kj7]

       Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
       with the following symbols:
         + create

       Terraform will perform the following actions:

         # yandex_compute_instance.instance will be created
         + resource "yandex_compute_instance" "instance" {
             + created_at                = (known after apply)
             + folder_id                 = "b1g9ofom2ntbfc8shnlh"
             + fqdn                      = (known after apply)
             + hostname                  = (known after apply)
             + id                        = (known after apply)
             + metadata                  = {
                 + "ssh-keys" = <<-EOT
                       centos:ssh-rsa AAAAB3NzaC1yc2EAAAA*****AAABAQCkGrgH7wiBVjDd7jNHihtG+lwBqLZXOAPirf1QqO4BrmklardHiVZ+ifVucS7CKPxV4/ak7qU5DrNw2YfCIVjE/NuCSI9rWp19BKK276wrcUQBYOCzEsHuzEA307aP8n2qj3CHcePoVbOwMuKhIBORzVKXj84n5MVoqElnWdYppONhn5yJ3huudQnX8SrVhkqeqfQKEegKPZX8EoMNTh5l2cJZoIW4s3z+2JfedCVFbbGPxjJQH8/Ptb93m0wp5K+o8/DMZCB6EZGooEGevyqDVdReDHkR7i5igwGMOA7LQuUo5Z9eoIBBG58UDdXvKcFFvHVcoRIguWGlwQa7fkHF root@DevOps
                   EOT
               }
             + name                      = "centos-test"
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
                     + image_id    = "fd88d14a6790do254kj7"
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
                 + subnet_id          = "default"
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
       
![7_3_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_7_3/7_3_2.png)
