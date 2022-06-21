# Домашнее задание к занятию "6.3. MySQL"

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

### Ответ:

- root@DevOps:~#docker pull mysql:8
- root@DevOps:~#docker volume create volumemysql
- root@DevOps:~#docker run --name mysql -e MYSQL_ROOT_PASSWORD=mysql -p 3306:3306 -v volumemysql:/etc/mysql/volume -d mysql:8
- root@DevOps:~# docker exec -it 7f060a4edef8 bash
- root@7f060a4edef8:/etc/mysql/volume# mysql -p test_db < /etc/mysql/volume/test_dump.sql
- root@7f060a4edef8:/etc/mysql/volume# mysql -u root -p
- mysql> use test_db
- mysql> \s
>
    mysql  Ver 8.0.29 for Linux on x86_64 (MySQL Community Server - GPL)
    Connection id:		19
    Current database:	test_db
    Current user:		root@localhost
    SSL:			Not in use
    Current pager:		stdout
    Using outfile:		''
    Using delimiter:	;
    Server version:		8.0.29 MySQL Community Server - GPL
    Protocol version:	10
    Connection:		Localhost via UNIX socket
    Server characterset:	utf8mb4
    Db     characterset:	utf8mb4
    Client characterset:	latin1
    Conn.  characterset:	latin1
    UNIX socket:		/var/run/mysqld/mysqld.sock
    Binary data as:		Hexadecimal
    Uptime:			31 min 44 sec

mysql> show tables;
>
    +-------------------+
    | Tables_in_test_db |
    +-------------------+
    | orders            |
    +-------------------+
    1 row in set (0.00 sec)

mysql> select count(*) from orders where price >300;
>
    +----------+
    | count(*) |
    +----------+
    |        1 |
    +----------+
    1 row in set (0.00 sec)

![скрин 6_3_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_6_3/6_3_1.png)

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.
