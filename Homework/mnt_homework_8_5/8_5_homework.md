# Домашнее задание к занятию "08.05 Тестирование Roles"

## Подготовка к выполнению
1. Установите molecule: `pip3 install "molecule==3.5.2"`
2. Выполните `docker pull aragast/netology:latest` -  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри

---
### Ответ:
---

1. Устанавливаем `molecule` и проверяем:

![8_5_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_5/8_5_1.png)

2. Скачиваем и проверяем docker-образ:

![8_5_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_5/8_5_2.png)


## Основная часть

Наша основная цель - настроить тестирование наших ролей. Задача: сделать сценарии тестирования для vector. Ожидаемый результат: все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos7` внутри корневой директории clickhouse-role, посмотрите на вывод команды.
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
4. Добавьте несколько assert'ов в verify.yml файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска, etc). Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

---
### Ответ:
---

1. Проверяем работу `molecule` в директории clickhouse:

![8_5_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_5/8_5_3.png)

2. Создаем сценарий тестирования для роли `vector-role`:

![8_5_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_5/8_5_4.png)

3. Добавляем дистрибутивы в файл `molecule.yml`:

> 
    platforms:
      - name: centos_7
        image: centos:7
        pre_build_image: true
      - name: centos_8
        image: centos:8_update
        pre_build_image: true
      - name: ubuntu
        image: ubuntu:python
        pre_build_image: true
        
Проверяем работу `molecule test`:

![8_5_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_5/8_5_5.png)

Полный результат работы в файле: [molecule_test.md](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_5/molecule_test.md)

4. Добавляем assert в verify.yml и запускаем `molecule test` снова:

![8_5_6.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_5/8_5_6.png)

5. Ссылка на коммит с рабочим сценарием: [molecule](https://github.com/psvitov/mnt_homework_8_5/tree/v0.0.3)


### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example)
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo - путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini` для того чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Ссылка на репозиторий являются ответами на домашнее задание. Не забудьте указать в ответе теги решений Tox и Molecule заданий.

---
### Ответ:
---

1. Файлы добавлены, контейнер запущен:

![8_5_7.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_5/8_5_7.png)

2. Исправляем tox.ini для проверки своей роли `default`, запускаем `tox`, команда завершается ошибками, так как в образе не установлен `docker`

![8_5_8.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_5/8_5_8.png)

3. Меняем драйвер на `podman` и облегчаем сценарий

> 
    [tox]
    minversion = 1.8
    basepython = python3.6
    envlist = py{37,39}-ansible{210}
    skipsdist = true

    [testenv]
    passenv = *
    deps =
        -r tox-requirements.txt
        ansible210: ansible<3.0
    commands =
        {posargs:molecule test -s default --destroy always}
        
4. Запуск tox прошел по сценарию molecule, но завершился ошибками. Вероятнее всего, при работе с molecule использовались docker-образы собственной сборки(ubuntu не имеет в контейнере python, в контейнере centos:8 необходимо было поправить работу репозитория, так как не отрабатывал dnf):

![8_5_9.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_5/8_5_9.png)

5. Ссылка на коммит с рабочим сценарием: [tox](https://github.com/psvitov/mnt_homework_8_5/tree/v0.0.4)
