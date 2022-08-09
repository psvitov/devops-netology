# Домашнее задание к занятию "09.01 Жизненный цикл ПО"

## Подготовка к выполнению
1. Получить бесплатную [JIRA](https://www.atlassian.com/ru/software/jira/free)
2. Настроить её для своей "команды разработки"
3. Создать доски kanban и scrum

---
### Ответ:
---

Регистрация, настройка и создание досок `kanban` и `scrum`:

![9_1_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_1/9_1_2.png)

## Основная часть
В рамках основной части необходимо создать собственные workflow для двух типов задач: bug и остальные типы задач. Задачи типа bug должны проходить следующий жизненный цикл:
1. Open -> On reproduce
2. On reproduce -> Open, Done reproduce
3. Done reproduce -> On fix
4. On fix -> On reproduce, Done fix
5. Done fix -> On test
6. On test -> On fix, Done
7. Done -> Closed, Open

Остальные задачи должны проходить по упрощённому workflow:
1. Open -> On develop
2. On develop -> Open, Done develop
3. Done develop -> On test
4. On test -> On develop, Done
5. Done -> Closed, Open

Создать задачу с типом bug, попытаться провести его по всему workflow до Done. Создать задачу с типом epic, к ней привязать несколько задач с типом task, провести их по всему workflow до Done. При проведении обеих задач по статусам использовать kanban. Вернуть задачи в статус Open.
Перейти в scrum, запланировать новый спринт, состоящий из задач эпика и одного бага, стартовать спринт, провести задачи до состояния Closed. Закрыть спринт.

Если всё отработало в рамках ожидания - выгрузить схемы workflow для импорта в XML. Файлы с workflow приложить к решению задания.

---
### Ответ:
---

1. Создаем 2 проекта - `kanban-project` и `scrum-project`:

![9_1_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_1/9_1_2.png)

2. Добавляем необходимые статусы:

![9_1_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_1/9_1_3.png)

3. Добавляем `workflow` и активируем их:

![9_1_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_1/9_1_4.png)

4. Добавляем в схемы необходимые статусы и переходы:

![9_1_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_1/9_1_5.png)

![9_1_6.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_1/9_1_6.png)

5. Создаем задачи типа `bug`, `epic` и 2 задачи типа `task` с привязкой к задаче `epic`:

![9_1_7.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_1/9_1_7.png)

6. Проводим `bug` и `task-test2` до статуса `Done` и после возвращаем в статус `Open`:

![9_1_8.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_1/9_1_8.png)

![9_1_9.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_1/9_1_9.png)

![9_1_10.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_1/9_1_10.png)

![9_1_11.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_1/9_1_11.png)

7. Планируем новый `sprint`:

![9_1_12.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_1/9_1_12.png)

8. Доводим задачи до состояния `closed`:

![9_1_13.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_1/9_1_13.png)

![9_1_14.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_1/9_1_14.png)

9. Закрываем `sprint`:

![9_1_15.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_1/9_1_15.png)

10. Выгруженные схемы `workflow`:

- [bug workflow](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_1/bug%20workflow.xml)
- [other workflow](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_1/other%20workfows.xml)
