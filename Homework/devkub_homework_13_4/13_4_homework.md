# Домашнее задание к занятию "13.4 инструменты для упрощения написания конфигурационных файлов. Helm и Jsonnet"
В работе часто приходится применять системы автоматической генерации конфигураций. Для изучения нюансов использования разных инструментов нужно попробовать упаковать приложение каждым из них.

Проверяем наличие установленного `helm`, наличие кластера:

![13_4_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_4/13_4_1.png)


## Задание 1: подготовить helm чарт для приложения
Необходимо упаковать приложение в чарт для деплоя в разные окружения. Требования:
* каждый компонент приложения деплоится отдельным deployment’ом/statefulset’ом;
* в переменных чарта измените образ приложения для изменения версии.

---
### Ответ:
---

Для выполнения ДЗ будем использовать манифесты из ДЗ 13.2.

1. Создадим шаблон чарта `helm`:

![13_4_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_4/13_4_2.png)


2. Создадим 3 отдельных `deploymetn` и добавим новые переменные в `values.yaml`:

- [Frontend](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_4/deploy-f.yml)
- [Backend](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_4/deploy-b.yml)
- [PVC](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_4/deploy-pvc.yml)
- [values.yaml](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_4/values.yaml)

3. Проведем проверку:

![13_4_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_4/13_4_3.png)

4. Создадим новый `namespace=app0` и развернем созданный helm-чарт:

```
[root@master-host devops]# kubectl create namespace app0
namespace/app0 created
[root@master-host devops]# helm install -n app0 basic-release basic
NAME: basic-release
LAST DEPLOYED: Thu Nov 24 19:04:54 2022
NAMESPACE: app0
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace app0 -l "app.kubernetes.io/name=basic,app.kubernetes.io/instance=basic-release" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace app0 $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace app0 port-forward $POD_NAME 8080:$CONTAINER_PORT
```

5. Результат выполнения:

![13_4_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_4/13_4_4.png)


## Задание 2: запустить 2 версии в разных неймспейсах
Подготовив чарт, необходимо его проверить. Попробуйте запустить несколько копий приложения:
* одну версию в namespace=app1;
* вторую версию в том же неймспейсе;
* третью версию в namespace=app2.

---
### Ответ:
---

1. Создадим необходимые `namespace`:

```
[root@master-host devops]# kubectl create namespace app1
namespace/app1 created
[root@master-host devops]# kubectl create namespace app2
namespace/app2 created
```

2. Запустим приложение в `namespace=app1`:

![13_4_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_4/13_4_5.png)

3. Изменим в файле `Chart.yaml` версию чарта на 0.1.1, версию `nginx=1.22.0` и проведем `upgrade`:

```
[root@master-host devops]# helm upgrade -n app1 basic-release basic
Release "basic-release" has been upgraded. Happy Helming!
NAME: basic-release
LAST DEPLOYED: Thu Nov 24 19:43:47 2022
NAMESPACE: app1
STATUS: deployed
REVISION: 2
TEST SUITE: None
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace app1 -l "app.kubernetes.io/name=basic,app.kubernetes.io/instance=basic-release" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace app1 $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace app1 port-forward $POD_NAME 8080:$CONTAINER_PORT
```

4. Проверим обновление версии:

![13_4_6.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_4/13_4_6.png)

5. Изменим в файле `Chart.yaml` версию чарта на 0.1.2 и развернем приложение в `namespace=app2`:

![13_4_7.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_4/13_4_7.png)

P.S.: Поды в ожидании, потому что pvc не поднимается через деплой, прочитал, что необходимо его предварительно разворачивать через описание `job` в tpl-файле, попробовал, но не получилось. Прошу подсказать по данному вопросу.


