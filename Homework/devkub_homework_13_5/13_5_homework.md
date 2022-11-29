# Домашнее задание к занятию "13.5 поддержка нескольких окружений на примере Qbec"
Приложение обычно существует в нескольких окружениях. Для удобства работы следует использовать соответствующие инструменты, например, Qbec.

## Задание 1: подготовить приложение для работы через qbec
Приложение следует упаковать в qbec. Окружения должно быть 2: stage и production. 

Требования:
* stage окружение должно поднимать каждый компонент приложения в одном экземпляре;
* production окружение — каждый компонент в трёх экземплярах;
* для production окружения нужно добавить endpoint на внешний адрес.

---
### Ответ
---

Используем кластер из предыдущих ДЗ.

1. Проверим версию `qbec`, создадим новую конфигурацию `qtest`:

![13_5_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_5/13_5_1.png)

2. Cоздадим 2 окружения: `stage` с явным указанием параметров в файле и `prod` с подключением файла `prod.libsonnet`:

```
### stage.jsonnet

local prefix = 'stage';

[
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: prefix + '-deploy',
    },
    spec: {
      replicas: 1,
      selector: {
        matchLabels: {
          app: prefix + '-app',
          tier: prefix
        },
      },
      template: {
        metadata: {
          labels: {
            app: prefix + '-app',
            tier: prefix
          },
	},
	spec: {
          containers: [
            {
              name: prefix + '-front',
              image: 'nginx:stable',
              imagePullPolicy: 'Always',
            },
            {
              name: prefix + '-back',
              image: 'busybox',
              command: ["sleep", "36000"],
            },
          ],
	},
      },
    },
  },
]
```

[stage.jsonnet](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_5/stage.jsonnet)

```
### prod.jsonnet

local p = import '../params.libsonnet';
local params = p.components.prod;
local prefix = 'prod';

[
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: prefix + '-deploy',
    },
    spec: {
      replicas: params.replicas,
      selector: {
        matchLabels: {
          app: prefix + '-app',
          tier: prefix
        },
      },
      template: {
        metadata: {
          labels: {
            app: prefix + '-app',
            tier: prefix
          },
	},
	spec: {
          containers: [
            {
              name: prefix + '-front',
              image: params.fimage,
              imagePullPolicy: 'Always',
            },
            {
              name: prefix + '-back',
              image: params.bimage,
              command: ["sleep", "36000"],
            },
          ],
	},
      },
    },
  },
]
```
[prod.jsonnet](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_5/prod.jsonnet)

```
### prod.libsonnet

// this file has the baseline default parameters
{
  components: { // required
    prod: {
      replicas: 3,
      fimage: 'nginx:stable',
      bimage: 'busybox'
    },
  },
}
```
[prod.libsonnet](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_5/prod.libsonnet)

3. Создадим `namespace` "qbec-prod" и изменим файл `qbec.yaml`:

```
apiVersion: qbec.io/v1alpha1
kind: App
metadata:
  name: kube
spec:
  environments:
    default:
      defaultNamespace: default
      server: https://127.0.0.1:6443
    prod:
      defaultNamespace: qbec-prod
      server: https://127.0.0.1:6443
  vars: {}
```
[qbec.yaml](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_5/qbec.yaml)

4. Проверим наличие компонентов, `namespace` и проверим валидацию:

![13_5_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_5/13_5_2.png)

5. Разврачиваем окружение:

![13_5_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_5/13_5_3.png)

6. Проверяем наличие развернутых подов и доступ извне:

![13_5_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_5/13_5_4.png)

![13_5_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_5/13_5_5.png)
