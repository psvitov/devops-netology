# Домашнее задание к занятию "09.04 Jenkins"

## Подготовка к выполнению

1. Создать 2 VM: для jenkins-master и jenkins-agent.
2. Установить jenkins при помощи playbook'a.
3. Запустить и проверить работоспособность.
4. Сделать первоначальную настройку.

---
### Ответ:
---

1. Подготовлены 2 ВМ:

![9_4_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_4/9_4_1.png)

2. Устанавливаем jenkins при помощи playbook'a:

![9_4_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_4/9_4_2.png)

3. Проверка работоспособности и первоначальная настройка:

![9_4_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_4/9_4_3.png)

## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.
4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.
5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline).
6. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True), по умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.
7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.
8. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.

---
### Ответ:
---

1. Создаем `Freestyle Job`, настраиваем сборку и запускаем:

![9_4_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_4/9_4_4.png)

![9_4_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_4/9_4_5.png)

Результат запуска: [Freestyle Job](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_4/freestyle_job.md)



## Необязательная часть

1. Создать скрипт на groovy, который будет собирать все Job, которые завершились хотя бы раз неуспешно. Добавить скрипт в репозиторий с решением с названием `AllJobFailure.groovy`.
2. Создать Scripted Pipeline таким образом, чтобы он мог сначала запустить через Ya.Cloud CLI необходимое количество инстансов, прописать их в инвентори плейбука и после этого запускать плейбук. Тем самым, мы должны по нажатию кнопки получить готовую к использованию систему.

---
