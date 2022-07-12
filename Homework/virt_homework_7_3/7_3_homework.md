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
