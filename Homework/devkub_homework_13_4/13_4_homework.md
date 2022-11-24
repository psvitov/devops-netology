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





## Задание 2: запустить 2 версии в разных неймспейсах
Подготовив чарт, необходимо его проверить. Попробуйте запустить несколько копий приложения:
* одну версию в namespace=app1;
* вторую версию в том же неймспейсе;
* третью версию в namespace=app2.

---
### Ответ:
---




