# Домашнее задание к занятию "6.2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

### Ответ:

Команды: 

- root@DevOps:~/psql# docker pull postgres:12-alpine
- root@DevOps:~/psql# docker volume create --name volume1
- root@DevOps:~/psql# docker volume create --name volume2
- root@DevOps:~/psql# docker run --rm --name PSQL -e POSTGRES_PASSWORD=postgres -p 5432:5432 -v volume1:/var/lib/docker/volumes/volume1 -v volume2:/var/lib/docker/volumes/volume2 -d postgres:12-alpine
- root@DevOps:~/psql# docker exec -it d684e2031d76 bash
- bash-5.1# psql -h localhost -p 5432 -U postgres -W <p>
Скриншот 6_2_1.png

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

### Ответ:
    
- Список БД - скриншот 6_2_2.png
- Описание таблиц - скриншоты 6_2_3.png, 6_2_4.png
- SQL-запрос и список пользователей с правами над таблицами test_db - скриншоты 6_2_5.png, 6_2_6.png

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 

### Ответ:
- test_db=# SELECT * FROM orders;
- test_db=# select count (*) from orders;
- test_db=# SELECT * FROM clients;
- test_db=# select count (*) from clients;
<p>
Скриншот выполнения - 6_2_7.png

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.
Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

### Ответ:
  
- test_db=# update  clients set booking = 3 where id = 1;
- test_db=# update  clients set booking = 4 where id = 2;
- test_db=# update  clients set booking = 5 where id = 3;

- test_db=# SELECT * FROM clients;
- test_db=# SELECT * FROM clients as c where exists (select id from orders as o where c.booking = o.id);
<p>
Скриншот выполнения - 6_2_8.png

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.
  
### Ответ:

Скриншот выполнения - 6_2_9.png
  
- Seq Scan - чтение данных из таблицы последовательное
- cost=0.00..18.10 - затраты на получение первой строки..затраты на получение всех строк
- rows=810 width=72 - количество возвращаемых строк при выполнении операции Seq Scan и средний размер одной строки в байтах

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
Остановите контейнер с PostgreSQL (но не удаляйте volumes).
Поднимите новый пустой контейнер с PostgreSQL.
Восстановите БД test_db в новом контейнере.
Приведите список операций, который вы применяли для бэкапа данных и восстановления. 
	
### Ответ:
	
- bash-5.1# pg_dump -U postgres test_db -f /var/lib/docker/volumes/volume1/backup_test_db.sql
- root@DevOps:~/psql# docker stop d684e2031d76
- root@DevOps:~/psql# docker run --rm --name PSQL -e POSTGRES_PASSWORD=postgres -p 5452:5452 -v volume1:/var/lib/docker/volumes/volume1 -v volume2:/var/lib/docker/volumes/volume2 -d postgres:12-alpine
- postgres=# CREATE DATABASE test_db;
- bash-5.1# psql -U postgres test_db -f /var/lib/docker/volumes/volume1/backup_test_db.sql
