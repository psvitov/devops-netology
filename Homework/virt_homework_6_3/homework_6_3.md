# Домашнее задание к занятию "6.3. MySQL"

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

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
    
 Количество записей с price > 300: 1 запись.

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

### Ответ:

Создание пользователя:
>
    mysql> create user test@localhost identified by 'test-pass';
    Query OK, 0 rows affected (0.07 sec)

Срок истечения пароля:
>
    mysql> ALTER USER test@localhost
        -> PASSWORD EXPIRE INTERVAL 180 DAY;
    Query OK, 0 rows affected (0.05 sec)
    
Количество попыток авторизации:
>
    mysql> ALTER USER test@localhost
        -> FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2;
    Query OK, 0 rows affected (0.07 sec)
 
Максимальное количество запросов в час:
>
    mysql> ALTER USER test@localhost
        -> with
        -> MAX_QUERIES_PER_HOUR 100;
    Query OK, 0 rows affected (0.04 sec)
    
Аттрибуты пользователя:
>
    mysql> ALTER USER test@localhost 
        -> ATTRIBUTE '{"fname":"James", "lname":"Pretty"}';
    Query OK, 0 rows affected (0.04 sec)
    
Предоставление привилегий:
>
    mysql> GRANT Select ON test_db.orders TO 'test'@'localhost';
    Query OK, 0 rows affected, 1 warning (0.08 sec)
    
Данные по пользователю 'test':
>
    mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';
    +------+-----------+---------------------------------------+
    | USER | HOST      | ATTRIBUTE                             |
    +------+-----------+---------------------------------------+
    | test | localhost | {"fname": "James", "lname": "Pretty"} |
    +------+-----------+---------------------------------------+
    1 row in set (0.00 sec)

![скрин 6_3_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_6_3/6_3_2.png)

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

### Ответ:

Установка профилирования:
>
    mysql> SET profiling = 1;
    Query OK, 0 rows affected, 1 warning (0.00 sec)

Используемый `engine` в таблице БД - InnoDB:
>
    mysql> SELECT TABLE_NAME,ENGINE,ROW_FORMAT,TABLE_ROWS,DATA_LENGTH,INDEX_LENGTH FROM information_schema.TABLES
    -> WHERE table_name = 'orders' and  TABLE_SCHEMA = 'test_db' ORDER BY ENGINE asc;
    +------------+--------+------------+------------+-------------+--------------+
    | TABLE_NAME | ENGINE | ROW_FORMAT | TABLE_ROWS | DATA_LENGTH | INDEX_LENGTH |
    +------------+--------+------------+------------+-------------+--------------+
    | orders     | InnoDB | Dynamic    |          5 |       16384 |            0 |
    +------------+--------+------------+------------+-------------+--------------+
    1 row in set (0.01 sec)

Устанавливаем `MyISAM`:
>
    mysql> ALTER TABLE orders ENGINE = MyISAM;
    Query OK, 5 rows affected (0.49 sec)
    Records: 5  Duplicates: 0  Warnings: 0

Время выполнения - `0.49 sec`

Вывод команды `SHOW PROFILE;`:
>
    mysql> SHOW PROFILE;
    +--------------------------------+----------+
    | Status                         | Duration |
    +--------------------------------+----------+
    | starting                       | 0.000150 |
    | Executing hook on transaction  | 0.000016 |
    | starting                       | 0.000034 |
    | checking permissions           | 0.000015 |
    | checking permissions           | 0.000012 |
    | init                           | 0.000024 |
    | Opening tables                 | 0.000664 |
    | setup                          | 0.000303 |
    | creating table                 | 0.001807 |
    | waiting for handler commit     | 0.000030 |
    | waiting for handler commit     | 0.042674 |
    | After create                   | 0.000313 |
    | System lock                    | 0.000008 |
    | copy to tmp table              | 0.006423 |
    | waiting for handler commit     | 0.000007 |
    | waiting for handler commit     | 0.000008 |
    | waiting for handler commit     | 0.000019 |
    | rename result table            | 0.000041 |
    | waiting for handler commit     | 0.145009 |
    | waiting for handler commit     | 0.000012 |
    | waiting for handler commit     | 0.048874 |
    | waiting for handler commit     | 0.000009 |
    | waiting for handler commit     | 0.100553 |
    | waiting for handler commit     | 0.000008 |
    | waiting for handler commit     | 0.049243 |
    | end                            | 0.075546 |
    | query end                      | 0.024697 |
    | closing tables                 | 0.000008 |
    | waiting for handler commit     | 0.000014 |
    | freeing items                  | 0.000171 |
    | cleaning up                    | 0.000059 |
    +--------------------------------+----------+

Устанавливаем `InnoDB`:
>
    mysql> ALTER TABLE orders ENGINE = InnoDB;
    Query OK, 5 rows affected (0.37 sec)
    Records: 5  Duplicates: 0  Warnings: 0

Время выполнения - `0.37 sec`

Вывод команды `SHOW PROFILE;`:
>
    mysql> SHOW PROFILE;
    +--------------------------------+----------+
    | Status                         | Duration |
    +--------------------------------+----------+
    | starting                       | 0.000053 |
    | Executing hook on transaction  | 0.000004 |
    | starting                       | 0.000015 |
    | checking permissions           | 0.000004 |
    | checking permissions           | 0.000005 |
    | init                           | 0.000009 |
    | Opening tables                 | 0.000152 |
    | setup                          | 0.000044 |
    | creating table                 | 0.000059 |
    | After create                   | 0.169497 |
    | System lock                    | 0.000014 |
    | copy to tmp table              | 0.000060 |
    | rename result table            | 0.000614 |
    | waiting for handler commit     | 0.000007 |
    | waiting for handler commit     | 0.033241 |
    | waiting for handler commit     | 0.000007 |
    | waiting for handler commit     | 0.100625 |
    | waiting for handler commit     | 0.000012 |
    | waiting for handler commit     | 0.016823 |
    | waiting for handler commit     | 0.000007 |
    | waiting for handler commit     | 0.032818 |
    | end                            | 0.001104 |
    | query end                      | 0.015390 |
    | closing tables                 | 0.000007 |
    | waiting for handler commit     | 0.000017 |
    | freeing items                  | 0.000017 |
    | cleaning up                    | 0.000016 |
    +--------------------------------+----------+



## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

### Ответ:

Измененый файл`my.cnf`:
>
    root@7f060a4edef8:/etc/mysql# cat my.cnf
    [mysqld]
    pid-file        = /var/run/mysqld/mysqld.pid
    socket          = /var/run/mysqld/mysqld.sock
    datadir         = /var/lib/mysql
    secure-file-priv= NULL

    #Скорость IO
    innodb_flush_log_at_trx_commit = 0
    
    #Сжатие таблиц
    innodb_file_format = Barracuda
    
    #Размер буффера с незакомиченными транзакциями
    innodb_log_buffer_size = 1M
    
    #Буфер кеширования
    key_buffer_size = 4096M
    
    #Размер файла логов операций
    max_binlog_size = 100M
    
    # Custom config should go here
    !includedir /etc/mysql/conf.d/
    
![скрин 6_3_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_6_3/6_3_3.png)
