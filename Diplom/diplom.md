# Дипломный практикум в Yandex.Cloud

## 1 этап выполнения

---
### Создание облачной инфраструктуры
---

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


---

## 2 этап выполнения

---
### Создание Kubernetes кластера
---

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

---
### Создание тестового приложения

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

---
### Подготовка cистемы мониторинга и деплой приложения

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

---
### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/) либо [gitlab ci](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/)

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистр, а также деплой соответствующего Docker образа в кластер Kubernetes.

---
## Что необходимо для сдачи задания?

1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.
2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud.
3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.
4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.
5. Репозиторий с конфигурацией Kubernetes кластера.
6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.
7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)
