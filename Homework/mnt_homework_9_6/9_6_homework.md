# Домашнее задание к занятию "09.06 Gitlab"

## Подготовка к выполнению

1. Необходимо [подготовить gitlab к работе по инструкции](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/gitlab-containers)
2. Создайте свой новый проект
3. Создайте новый репозиторий в gitlab, наполните его [файлами](./repository)
4. Проект должен быть публичным, остальные настройки по желанию

---
### Ответ:
---

Подготовлен кластер `GitLab`, создан новый проект, новый репозиторий, файл добавлен в репозиторий:

![9_6_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_6/9_6_1.png)


## Основная часть

### DevOps

В репозитории содержится код проекта на python. Проект - RESTful API сервис. Ваша задача автоматизировать сборку образа с выполнением python-скрипта:
1. Образ собирается на основе [centos:7](https://hub.docker.com/_/centos?tab=tags&page=1&ordering=last_updated)
2. Python версии не ниже 3.7
3. Установлены зависимости: `flask` `flask-restful`
4. Создана директория `/python_api`
5. Скрипт из репозитория размещён в /python_api
6. Точка вызова: запуск скрипта
7. Если сборка происходит на ветке `master`: должен подняться pod kubernetes на основе образа `python-api`, иначе этот шаг нужно пропустить

---
### Ответ:
---

1. Создаем `dockerfile` для создания образа с нужными настройками:

#### dockerfile:

```
FROM centos:7

RUN yum install python3 python3-pip -y
RUN mkdir -p /python_api
ADD python-api.py /python_api/python-api.py
ADD requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
CMD ["python3", "/python_api/python-api.py"]
```

#### requirements.txt

```
flask
flask_restful
```
2. Создаем `.gitlab-ci.yml`:

```
stages:
  - build
  - deploy

build:
  stage: build
  variables:
    DOCKER_DRIVER: overlay2
    DOCKER_TLS_CERTDIR: ""
    DOCKER_HOST: tcp://localhost:2375/
  image: cr.yandex/yc/metadata-token-docker-helper:0.2
  services:
    - docker:19.03.1-dind
  script:
    - docker build . -t cr.yandex/crpql4d1nf2pqdqkveb7/python-api:latest-$CI_COMMIT_SHORT_SHA
  except:
    - main

deploy:
  stage: deploy
  variables:
    DOCKER_DRIVER: overlay2
    DOCKER_TLS_CERTDIR: ""
    DOCKER_HOST: tcp://localhost:2375/
  image: cr.yandex/yc/metadata-token-docker-helper:0.2
  services:
    - docker:19.03.1-dind
  script:
    - docker build . -t cr.yandex/crpql4d1nf2pqdqkveb7/python-api:latest-$CI_COMMIT_SHORT_SHA
    - docker push cr.yandex/crpql4d1nf2pqdqkveb7/python-api:latest-$CI_COMMIT_SHORT_SHA
  only:
    - main

```

3. После выполнения `commit` pipeline автоматически запускается:

![9_6_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_6/9_6_2.png)

### Product Owner

Вашему проекту нужна бизнесовая доработка: необходимо поменять JSON ответа на вызов метода GET `/rest/api/get_info`, необходимо создать Issue в котором указать:
1. Какой метод необходимо исправить
2. Текст с `{ "message": "Already started" }` на `{ "message": "Running"}`
3. Issue поставить label: feature

---
### Ответ:
---

1. Создаем новый `issue`:

![9_6_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_6/9_6_3.png)


### Developer

Вам пришел новый Issue на доработку, вам необходимо:
1. Создать отдельную ветку, связанную с этим issue
2. Внести изменения по тексту из задания
3. Подготовить Merge Request, влить необходимые изменения в `master`, проверить, что сборка прошла успешно

---
### Ответ:
---

1. Создаем отдельную ветку, связанную с `issue`:

![9_6_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_6/9_6_4.png)

2. В репозитории в созданной ветке производим изменения, запускаем `commit` и проверяем работу `pipeline`:

![9_6_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_6/9_6_5.png)

3. Проводим `merge` веток и  проверяем что работа прошла успешно:

![9_6_6.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_6/9_6_6.png)

![9_6_7.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_6/9_6_7.png)


### Tester

Разработчики выполнили новый Issue, необходимо проверить валидность изменений:
1. Поднять докер-контейнер с образом `python-api:latest` и проверить возврат метода на корректность
2. Закрыть Issue с комментарием об успешности прохождения, указав желаемый результат и фактически достигнутый

---
### Ответ:
---

1. Проверка проведена в поднятом докер-контейнере с образом `python-api:latest`
2. `issue` закрыт с комментарием об успешности прохождения:

![9_6_8.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_6/9_6_8.png)

Ссылка на репозиторий `GitLab`: [GitLab Repo](https://mnt-test.gitlab.yandexcloud.net/psvitov/gitlab-test.git)

