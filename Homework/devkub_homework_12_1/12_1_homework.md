# Домашнее задание к занятию "12.1 Компоненты Kubernetes"

Вы DevOps инженер в крупной компании с большим парком сервисов. Ваша задача — разворачивать эти продукты в корпоративном кластере. 

## Задача 1: Установить Minikube

Для экспериментов и валидации ваших решений вам нужно подготовить тестовую среду для работы с Kubernetes. Оптимальное решение — развернуть на рабочей машине Minikube.

---
### Ответ:
---

Разворачивание проводится на локальной машине:

1. Устанавливаем `Minikube`, все зависимости и проверяем версию:

![12_1_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_12_1/12_1_1.png)

2. Запускаем `Minikube` и проверяем работоспособность:

![12_1_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_12_1/12_1_2.png)


## Задача 2: Запуск Hello World
После установки Minikube требуется его проверить. Для этого подойдет стандартное приложение hello world. А для доступа к нему потребуется ingress.

- развернуть через Minikube тестовое приложение по [туториалу](https://kubernetes.io/ru/docs/tutorials/hello-minikube/#%D1%81%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BA%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%B0-minikube)
- установить аддоны ingress и dashboard

---
### Ответ:
---

1. Создаем `Deployment` и проверяем:

![12_1_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_12_1/12_1_3.png)

2. Создаем сервис и проверяем:

![12_1_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_12_1/12_1_4.png)

3. проверяем работу тестового приложения:

![12_1_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_12_1/12_1_5.png)

4. Устанавливаем аддоны `ingress` и `dashboard`:

![12_1_6.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_12_1/12_1_6.png)

Работа дашбоарда:

![12_1_7.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_12_1/12_1_7.png)


## Задача 3: Установить kubectl

Подготовить рабочую машину для управления корпоративным кластером. Установить клиентское приложение kubectl.
- подключиться к minikube 
- проверить работу приложения из задания 2, запустив port-forward до кластера

---
### Ответ:
---

1. Установка и проверка `kubectl`, подключение к `Minikube`:

![12_1_8.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_12_1/12_1_8.png)

2. Работа приложения через `port-forward`:

![12_1_9.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_12_1/12_1_9.png)
![12_1_10.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_12_1/12_1_10.png)

