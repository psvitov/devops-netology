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
2. Создайте два воркспейса `stage` и `prod`.
3. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
использовались разные `instance_type`.
4. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два. 
5. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
6. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
7. При желании поэкспериментируйте с другими параметрами и рессурсами.

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
         
4. В `main.tf` добавляем блоки `module` и `locals`:

в блоке `module` описывается образ используемых ресурсов для создания виртуальной машины

> 
    module "test" {
      source = "./modules"
      instance_count = local.test_instance_count
      subnet_id     = local.vpc_subnets
      zone = var.yc_region
      folder_id = var.yc_folder_id
      image         = "centos-7"
      platform_id   = "standard-v1"
      name          = "test"
      description   = "Test Terraform"
      instance_role = "test instance"
      users         = "centos"
      cores         = local.test_cores
      boot_disk     = "network-ssd"
      disk_size     = local.test_disk_size
      nat           = "true"
      memory        = "4"
      core_fraction = "20"  
    }

В блоке `locals` описывается локальная конфигурация значений, используемых в `module`

> 
    locals {
      test_cores = {
        stage = 1
        prod = 1
      }
      test_disk_size = {
        stage = 40
        prod = 40
      }
      test_instance_count = {
        stage = 1
        prod = 2
      }
      vpc_subnets = {
        stage = [
          {
            "v4_cidr_blocks": [
              "10.0.0.1/24"
            ],
            "zone": var.yc_region
          }
        ]
        prod = [
          {
            "v4_cidr_blocks": [
              "10.0.0.1/24"
            ],
            "zone": var.yc_region
          }      
        ]
      }
    }

5. Создаем в папке modules файл с описанием `instance.tf`:

[instance.tf](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_7_3/instance.tf)

`terraform init` проходит без ошибки, `terraform plan` выдает ошибку:

![7_3_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_7_3/7_3_2.png)


