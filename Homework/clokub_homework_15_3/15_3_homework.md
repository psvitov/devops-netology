# Домашнее задание к занятию 15.3 "Безопасность в облачных провайдерах"
Используя конфигурации, выполненные в рамках предыдущих домашних заданиях, нужно добавить возможность шифрования бакета.

---
## Задание 1. Яндекс.Облако (обязательное к выполнению)
1. С помощью ключа в KMS необходимо зашифровать содержимое бакета:
- Создать ключ в KMS,
- С помощью ключа зашифровать содержимое бакета, созданного ранее.
2. (Выполняется НЕ в terraform) *Создать статический сайт в Object Storage c собственным публичным адресом и сделать доступным по HTTPS
- Создать сертификат,
- Создать статическую страницу в Object Storage и применить сертификат HTTPS,
- В качестве результата предоставить скриншот на страницу с сертификатом в заголовке ("замочек").

---
### Ответ:
---

1. Возьмем за основу домашнее задание лекции "Вычислительные мощности"

2. Для определения переменных создадим файл variables.tf с содержимым:

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

Заранее определим зону ru-central1-a в файле variables.tf

3. В файле /.terraformrc укажем источник, из которого будет устанавливаться провайдер:

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

4. Создадим основной конфигурационный файл main.tf, добавим начальное содержимое:

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
  name        = "security"
  description = "Cloud Security"
}
```

6. Создадим сервисный аккаунт с ролью editor:

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

7. Создадим статический ключ доступа и бакет, с использованием этого статического ключа:

```
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

resource "yandex_storage_bucket" "bucket-sec" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "secure"
}
```

8. Создадим ключ в KMS:

```
resource "yandex_kms_symmetric_key" "key-a" {
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
  name              = "key-secure"
  description       = "KMS Cloud key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
  lifecycle {
    prevent_destroy = true
  }
}
```

и зашифруем содержимое бакета, добавив строки:


```
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

```

9. Для создания статической страницы в `Object Storage` воспользуемся инструкцией [ЯО](https://cloud.yandex.ru/docs/tutorials/web/static):

Создадим публичный бакет

![15_3_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_15_3/15_3_1.png)

и 2 файла - `index.html` и `error.html` с содержимым:

```
<html>
  <head>
    <title>Netology DevOps</title>
  </head>
  <body>
    <h2>Netology DevOps</h2>
  </body>
</html>
```

```
<html>
  <head>
    <title>Netology DevOps</title>
  </head>
  <body>
    <h2>ERROR!!!</h2>
  </body>
</html>
```

Загружаем 2 созданных файла в бакет и в бакете настраиваем хостинг

![15_3_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_15_3/15_3_2.png)


10. Создаем сертификат и проводим его валидацию:

![15_3_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_15_3/15_3_3.png)


11. Настраиваем доступ по HTTPS к статическому сайту:

![15_3_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_15_3/15_3_4.png)


12. Проверка доступности сертификата:

![15_3_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_15_3/15_3_5.png)


Так как ЯО не хотело принимать созданный сетрификат мотивируя:

"У вас пока нет ни одного подходящего сертификата: имя домена из списка доменов в сертификате должно совпадать с именем бакета"
пришлось создавать бакет с полным доменным именем, только после этого появился выбор сертификата.


Полный файл [main.tf](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_15_3/main.tf)


