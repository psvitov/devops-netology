# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

### Ответ:

root@DevOps:~# docker pull postgres:13
> 
    13: Pulling from library/postgres
    b85a868b505f: Pull complete 
    b53bada42f30: Pull complete 
    303bde9620f5: Pull complete 
    5c32c0c0a1b9: Pull complete 
    302630a57c06: Pull complete 
    ddfead4dfb39: Pull complete 
    03d9917b9309: Pull complete 
    4bb0d8ea11e0: Pull complete 
    005255133bfc: Pull complete 
    94310da79ee4: Pull complete 
    5d3d16b4d857: Pull complete 
    d02180ccce98: Pull complete 
    bd504a89674f: Pull complete 
    Digest: sha256:1336702a96b504ca9635a6c7d6128caa2a32365bcdd157f83daf41eec397f889
    Status: Downloaded newer image for postgres:13
    docker.io/library/postgres:13
    
root@DevOps:~# docker volume create psqlvol

root@DevOps:~# docker run --name psql -e POSTGRES_PASSWORD=postgres -p 5432:5432 -v psqlvol:/var/lib/docker/volumes/psqlvol -d postgres:13

root@DevOps:~# docker ps

>
    CONTAINER ID   IMAGE         COMMAND                  CREATED              STATUS              PORTS                                                NAMES
    42767000ac46   postgres:13   "docker-entrypoint.s…"   About a minute ago   Up About a minute   5432/tcp,        0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   psql

>   
    root@DevOps:~# docker exec -it 42767000ac46 bash
    root@42767000ac46:/# psql -h localhost -p 5432 -U postgres -W
    Password: 
    psql (13.7 (Debian 13.7-1.pgdg110+1))
    Type "help" for help.
    postgres=#
    
- Вывод списка БД:

>   \l[+]   [PATTERN]      list databases

> 
    postgres=# \l
                                     List of databases
       Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
    -----------+----------+----------+------------+------------+-----------------------
     postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
     template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
     template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
    (3 rows)
    
- Подключение к БД:

>   
    Connection
     \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                             connect to new database (currently "postgres")
                             
- Вывод списка таблиц:

>   
    \dt[S+] [PATTERN]      list tables
    
- Вывод описания содержимого таблиц:

>   
    \d[S+]                 list tables, views, and sequences
    \d[S+]  NAME           describe table, view, sequence, or index
    
- Выход из psql:

>   
    \q                     quit psql


## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

### Ответ:

- Создание БД `test_databse`:

> 
    postgres=# create database test_database;
    CREATE DATABASE
    postgres=# \l
                                       List of databases
         Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
    ---------------+----------+----------+------------+------------+-----------------------
     postgres      | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
     template0     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
                   |          |          |            |            | postgres=CTc/postgres
     template1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
                   |          |          |            |            | postgres=CTc/postgres
     test_database | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
    (4 rows)

- Восстановление бекапа БД:

> 
    root@42767000ac46:/var/lib/docker/volumes/psqlvol# psql -U postgres -f ./test_dump.sql test_database
    SET
    SET
    SET
    SET
    SET
     set_config 
    ------------
     
    (1 row)
    
    SET
    SET
    SET
    SET
    SET
    SET
    CREATE TABLE
    ALTER TABLE
    CREATE SEQUENCE
    ALTER TABLE
    ALTER SEQUENCE
    ALTER TABLE
    COPY 8
     setval 
    --------
          8
    (1 row)
    
    ALTER TABLE

- Подключение к восстановленной БД:

> 
    root@42767000ac46:/var/lib/docker/volumes/psqlvol# psql -h localhost -p 5432 -U postgres -W
    Password: 
    psql (13.7 (Debian 13.7-1.pgdg110+1))
    Type "help" for help.
    
    postgres=# \c test_database
    Password: 
    You are now connected to database "test_database" as user "postgres".
    test_database=#


- Сбор статистики по таблице:

> 
    test_database=# \dt
             List of relations
     Schema |  Name  | Type  |  Owner   
    --------+--------+-------+----------
     public | orders | table | postgres
    (1 row)
    
    test_database=# ANALYZE VERBOSE public.orders;
    INFO:  analyzing "public.orders"
    INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated    total rows
    ANALYZE

- Cтолбец таблицы `orders` с наибольшим средним значением размера элементов в байтах:

> 
    test_database=# select avg_width from pg_stats where tablename='orders';
     avg_width 
    -----------
             4
            16
             4
    (3 rows)


## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

---

