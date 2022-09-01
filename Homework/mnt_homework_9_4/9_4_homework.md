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

Результат запуска: [Freestyle Job](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_4/freestyle_job.txt)

Так как на `jenkins-agent` нет необходимых docker-контейнеров, которые использовались при выполнении ДЗ 8_5, задача вываливается с ошибкой.

2. Создаем `Declarative Pipeline Job`, настраиваем сборку и запускаем:

![9_4_6.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_4/9_4_6.png)

![9_4_7.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_4/9_4_7.png)

Результат запуска: [Declarative Pipeline Job](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_4/declarative_pipeline_job.txt)

Так как на `jenkins-agent` нет необходимых docker-контейнеров, которые использовались при выполнении ДЗ 8_5, задача вываливается с ошибкой.

3. Переносим `Declarative Pipeline Job` в репозиторий в файл [`Jenkinsfile`](https://github.com/psvitov/mnt_homework_8_5/blob/v0.0.5/Jenkinsfile)

![9_4_8.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_4/9_4_8.png)

4. Создаем `Multibranch Pipeline` на запуск `Jenkinsfile` из репозитория:

![9_4_9.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_4/9_4_9.png)

Результат запуска: [Multibranch Pipeline Job](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_4/multibranch.txt)

Так как на `jenkins-agent` нет необходимых docker-контейнеров, которые использовались при выполнении ДЗ 8_5, задача вываливается с ошибкой.

5. Создаем Scripted Pipeline, вносим необходимые изменения и проверяем арботоспособность:

![9_4_10.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_4/9_4_10.png)

![9_4_11.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_4/9_4_11.png)

![9_4_12.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_4/9_4_12.png)

Так как в `example-playbook/inventory/prod.yml` указан хост к которому нет доступа, то задание вываливается с ошибкой.

6. Добавляем `ScriptedJenkinsfile` в репозиторий.

Ссылки на коммиты репозитория:

[`Declarative Pipeline`](https://github.com/psvitov/mnt_homework_8_5/tree/v0.0.5)
[`Scripted Pipeline`](https://github.com/psvitov/mnt_homework_8_5/tree/v0.0.6)

---
## Работа над ошибками
---

Доработал jenkins-agent

1. Результат выполнения Freestyle Job через [`docker`](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_4/freestyle_job_v2.txt)

2. Результат выполнения Freestyle Job через [`podman`](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_4/freestyle_job_podman.txt)

3. Результат выполнения Declarative Pipeline Job через [`podman`](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_4/declarative_pipeline_job_v2.txt)
