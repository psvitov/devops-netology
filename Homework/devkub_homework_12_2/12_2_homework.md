# Домашнее задание к занятию "12.2 Команды для работы с Kubernetes"
Кластер — это сложная система, с которой крайне редко работает один человек. Квалифицированный devops умеет наладить работу всей команды, занимающейся каким-либо сервисом.
После знакомства с кластером вас попросили выдать доступ нескольким разработчикам. Помимо этого требуется служебный аккаунт для просмотра логов.



## Задание 1: Запуск пода из образа в деплойменте
Для начала следует разобраться с прямым запуском приложений из консоли. Такой подход поможет быстро развернуть инструменты отладки в кластере. Требуется запустить деплоймент на основе образа из hello world уже через deployment. Сразу стоит запустить 2 копии приложения (replicas=2). 

Требования:
 * пример из hello world запущен в качестве deployment
 * количество реплик в deployment установлено в 2
 * наличие deployment можно проверить командой kubectl get deployment
 * наличие подов можно проверить командой kubectl get pods

---
### Ответ:
---

1. Создадим новый `deployment` через `yml-файл`, где укажем необходимое количество реплик:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world
  labels:
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```
2. Так же запустим пример из предыдущего задания, добавив 2 реплики:

```
kubectl create deployment hello-node --replicas=2 --image=k8s.gcr.io/echoserver:1.4
```

3. Результат запросов `kubectl get deployments`, `kubectl get pods`:

![12_2_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_12_2/12_2_1.png)


## Задание 2: Просмотр логов для разработки
Разработчикам крайне важно получать обратную связь от штатно работающего приложения и, еще важнее, об ошибках в его работе. 
Требуется создать пользователя и выдать ему доступ на чтение конфигурации и логов подов в app-namespace.

Требования: 
 * создан новый токен доступа для пользователя
 * пользователь прописан в локальный конфиг (~/.kube/config, блок users)
 * пользователь может просматривать логи подов и их конфигурацию (kubectl logs pod <pod_id>, kubectl describe pod <pod_id>)

---
### Ответ:
---

1. Создаем пользователя `devops`, роль `reader-pod`, привязываем роль к пользователю, генерируем токен и проверяем:

![12_2_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_12_2/12_2_2.png)

2. Добавляем токен в локальный конфиг:

![12_2_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_12_2/12_2_3.png)

3. Проверяем доступность:

![12_2_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_12_2/12_2_4.png)


## Задание 3: Изменение количества реплик 
Поработав с приложением, вы получили запрос на увеличение количества реплик приложения для нагрузки. Необходимо изменить запущенный deployment, увеличив количество реплик до 5. Посмотрите статус запущенных подов после увеличения реплик. 

Требования:
 * в deployment из задания 1 изменено количество реплик на 5
 * проверить что все поды перешли в статус running (kubectl get pods)

---
### Ответ:
---

1. `Deployment`, созданный с помощью файла увеличим командой:

```
kubectl scale --replicas=5 -f hello_world.yml
```

2. `Deployment` из предыдущего задания увеличим командой:

```
kubectl scale --replicas=5 deployment/hello-node
```

3. Результат:

![12_2_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_12_2/12_2_5.png)
