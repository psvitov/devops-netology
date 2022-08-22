# Домашнее задание к занятию "8.4 Работа с Roles"

## Подготовка к выполнению
1. (Необязательно) Познакомтесь с [lighthouse](https://youtu.be/ymlrNlaHzIY?t=929)
2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
3. Добавьте публичную часть своего ключа к своему профилю в github.

---
### Ответ:
---

1. Ознакомился с `lighthouse`.
2. Создано 2 новых репозитория `vector-role` и `lighthouse-role` и репозиторий с `playbook`:

![8_4_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_4/8_4_1.png)

3. Публичный ключ добавлен:

![8_4_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_4/8_4_2.png)



## Основная часть

Наша основная цель - разбить наш playbook на отдельные roles. Задача: сделать roles для clickhouse, vector и lighthouse и написать playbook для использования этих ролей. Ожидаемый результат: существуют три ваших репозитория: два с roles и один с playbook.

1. Создать в старой версии playbook файл `requirements.yml` и заполнить его следующим содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.11.0"
       name: clickhouse 
   ```

2. При помощи `ansible-galaxy` скачать себе эту роль.
3. Создать новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Описать в `README.md` обе роли и их параметры.
7. Повторите шаги 3-6 для lighthouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте тэги, используя семантическую нумерацию Добавьте roles в `requirements.yml` в playbook.
9. Переработайте playbook на использование roles. Не забудьте про зависимости lighthouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответ приведите ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---
### Ответ:
---

1. Создаем файл `requirements.yml` и добавляем необходимое содержимое:

![8_4_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_4/8_4_3.png)

2. Создаем папку `roles` и скачиваем туда роль при помощи `ansible-galaxy`:

![8_4_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_4/8_4_4.png)

3. Создаем роль `vector-role`:

![8_4_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_4/8_4_5.png)

Добавляем в файл `vars/main.yml` переменные:

![8_4_6.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_4/8_4_6.png)

Добавляем `tasks` в файл `tasks/main.yml`:

![8_4_7.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_4/8_4_7.png)

4. Создаем роль `lighthouse-role`:

![8_4_8.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_4/8_4_8.png)

Добавляем `tasks` в файл `tasks/main.yml`:

![8_4_9.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_4/8_4_9.png)

5. Выкладываем созданные роли в репозитории, созданные при подготовке:

`vector-role`:

![8_4_10.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_4/8_4_10.png)

`lighthouse-role`:

![8_4_11.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_4/8_4_11.png)

6. Добавление описания ролей в `README.md`:

![8_4_12.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_4/8_4_12.png)

![8_4_13.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_4/8_4_13.png)

7. Добавляем вновь созданные `roles` в `requirements.yml` в playbook:

![8_4_14.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_4/8_4_14.png)

8. Пересобираем `playbook` на использование ролей:

![8_4_15.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_4/8_4_15.png)

9. Ссылки на репозитории:

- [playbook](https://github.com/psvitov/mnt_homework_8_4)
- [vector-role](https://github.com/psvitov/vector-role)
- [lighthouse-role](https://github.com/psvitov/lighthouse-role)
