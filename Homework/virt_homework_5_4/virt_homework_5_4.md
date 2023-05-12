# Домашнее задание к занятию 4. «Оркестрация группой Docker-контейнеров на примере Docker Compose»

## Задача 1

Создайте собственный образ любой операционной системы (например ubuntu-20.04) с помощью Packer ([инструкция](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/packer-quickstart)).

Чтобы получить зачёт, вам нужно предоставить скриншот страницы с созданным образом из личного кабинета YandexCloud.

## Ответ:

После установки `Packer` произведем создание образа через утилиту Яндекс.Облако `yc` и проверим его создание:

---
![1_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_5_4/1_1.png)
---
![1_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_5_4/1_2.png)
---

## Задача 2

**2.1.** Создайте вашу первую виртуальную машину в YandexCloud с помощью web-интерфейса YandexCloud.        

## Ответ:

На основе ранее созданного образа создадим виртуальную машину:

---
![2_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_5_4/2_1.png)
---
![2_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_5_4/2_2.png)
---

## Задача 3

С помощью Ansible и Docker Compose разверните на виртуальной машине из предыдущего задания систему мониторинга на основе Prometheus/Grafana.
Используйте Ansible-код в директории ([src/ansible](https://github.com/netology-group/virt-homeworks/tree/virt-11/05-virt-04-docker-compose/src/ansible)).

## Ответ:

Настроим систему мониторинга на созданной виртуальной машине:

---
![add_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_5_4/add_3.png)
---
![add_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_5_4/add_4.png)
---

## Задача 4

1. Откройте веб-браузер, зайдите на страницу http://<внешний_ip_адрес_вашей_ВМ>:3000.
2. Используйте для авторизации логин и пароль из [.env-file](https://github.com/netology-group/virt-homeworks/blob/virt-11/05-virt-04-docker-compose/src/ansible/stack/.env).
3. Изучите доступный интерфейс, найдите в интерфейсе автоматически созданные docker-compose-панели с графиками([dashboards](https://grafana.com/docs/grafana/latest/dashboards/use-dashboards/)).
4. Подождите 5-10 минут, чтобы система мониторинга успела накопить данные.

## Ответ:

Скриншот интерфейса развернутого мониторинга:

![add_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_5_4/add_5.png)
