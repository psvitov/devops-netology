# Домашнее задание к занятию "10.02. Системы мониторинга"

## Обязательные задания

1. Опишите основные плюсы и минусы pull и push систем мониторинга.

2. Какие из ниже перечисленных систем относятся к push модели, а какие к pull? А может есть гибридные?

    - Prometheus 
    - TICK
    - Zabbix
    - VictoriaMetrics
    - Nagios

3. Склонируйте себе [репозиторий](https://github.com/influxdata/sandbox/tree/master) и запустите TICK-стэк, 
используя технологии docker и docker-compose.(по инструкции ./sandbox up )

В виде решения на это упражнение приведите выводы команд с вашего компьютера (виртуальной машины):

    - curl http://localhost:8086/ping
    - curl http://localhost:8888
    - curl http://localhost:9092/kapacitor/v1/ping

А также скриншот веб-интерфейса ПО chronograf (`http://localhost:8888`). 

P.S.: если при запуске некоторые контейнеры будут падать с ошибкой - проставьте им режим `Z`, например
`./data:/var/lib:Z`

4. Изучите список [telegraf inputs](https://github.com/influxdata/telegraf/tree/master/plugins/inputs).
    - Добавьте в конфигурацию telegraf плагин - [disk](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/disk):
    ```
    [[inputs.disk]]
      ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"]
    ```
    - Так же добавьте в конфигурацию telegraf плагин - [mem](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/mem):
    ```
    [[inputs.mem]]
    ```
    - После настройки перезапустите telegraf.
 
    - Перейдите в веб-интерфейс Chronograf (`http://localhost:8888`) и откройте вкладку `Data explorer`.
    - Нажмите на кнопку `Add a query`
    - Изучите вывод интерфейса и выберите БД `telegraf.autogen`
    - В `measurments` выберите mem->host->telegraf_container_id , а в `fields` выберите used_percent. 
    Внизу появится график утилизации оперативной памяти в контейнере telegraf.
    - Вверху вы можете увидеть запрос, аналогичный SQL-синтаксису. 
    Поэкспериментируйте с запросом, попробуйте изменить группировку и интервал наблюдений.
    - Приведите скриншот с отображением
    метрик утилизации места на диске (disk->host->telegraf_container_id) из веб-интерфейса.  

5. Добавьте в конфигурацию telegraf следующий плагин - [docker](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/docker):
```
[[inputs.docker]]
  endpoint = "unix:///var/run/docker.sock"
```

Дополнительно вам может потребоваться донастройка контейнера telegraf в `docker-compose.yml` дополнительного volume и 
режима privileged:
```
  telegraf:
    image: telegraf:1.4.0
    privileged: true
    volumes:
      - ./etc/telegraf.conf:/etc/telegraf/telegraf.conf:Z
      - /var/run/docker.sock:/var/run/docker.sock:Z
    links:
      - influxdb
    ports:
      - "8092:8092/udp"
      - "8094:8094"
      - "8125:8125/udp"
```

После настройки перезапустите telegraf, обновите веб интерфейс и приведите скриншотом список `measurments` в 
веб-интерфейсе базы telegraf.autogen . Там должны появиться метрики, связанные с docker.

Факультативно можете изучить какие метрики собирает telegraf после выполнения данного задания.

---
### Ответ:
---

1. `Pull` и `Push`-модели систем мониторинга:

- Push-модель – когда сервер мониторинга ожидает подключений от агентов для получения метрик;
- Pull-модель – когда сервер мониторинга сам подключается к агентам мониторинга и забирает данные.

#### `Pull`-модель

Плюсы:
- Удобна для использования в динамически создаваемых машинах, например в docker-контейнерах, так как можно сразу включить в образ агента и его настройки
- Гибкая настройка отправки данных на сервер, можно указать какие данные и как часто пересылать.


Минусы:
- Передача данных в открытом виде по сети, что небезопасно
- Нет гарантии доставки пакетов

#### `Push`-модель

Плюсы:
- Контроль над метриками с единой точки, всегда известно кто откуда что передает
- Защита соединения между агентами и сервером посредством proxy-server
- Возможность запроса метрик с внешней сети по HTTP-протоколу
- Разными системами мониторинга можно получать одни и теже метрики


Минусы:
- Неудобно использовать на динамически создаваемых машинах

2. Сравнение систем:

#### `Pull`-модели: 

Nagios

#### `Push`-модели: 

TICK, VictoriaMetrics

#### Гибридные модели:

Prometheus, Zabbix

3. Запускаем TICK-стек и проверяем работоспособность:

![10_2_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_10_2/10_2_1.png)

Вывод команды `curl http://localhost:8086/ping -v`

```
*   Trying ::1:8086...
* Connected to localhost (::1) port 8086 (#0)
> GET /ping HTTP/1.1
> Host: localhost:8086
> User-Agent: curl/7.74.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 204 No Content
< Content-Type: application/json
< Request-Id: ffaf5a9b-39c4-11ed-8051-0242ac130002
< X-Influxdb-Build: OSS
< X-Influxdb-Version: 1.8.10
< X-Request-Id: ffaf5a9b-39c4-11ed-8051-0242ac130002
< Date: Wed, 21 Sep 2022 15:49:38 GMT
< 
* Connection #0 to host localhost left intact
```

Вывод команды `curl http://localhost:8888 -v`

```
*   Trying ::1:8888...
* Connected to localhost (::1) port 8888 (#0)
> GET / HTTP/1.1
> Host: localhost:8888
> User-Agent: curl/7.74.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Accept-Ranges: bytes
< Cache-Control: public, max-age=3600
< Content-Length: 414
< Content-Security-Policy: script-src 'self'; object-src 'self'
< Content-Type: text/html; charset=utf-8
< Etag: ubyGAbz3Tc69bqd3w45d4WQtqoI=
< Vary: Accept-Encoding
< X-Chronograf-Version: 1.10.0
< X-Content-Type-Options: nosniff
< X-Frame-Options: SAMEORIGIN
< X-Xss-Protection: 1; mode=block
< Date: Wed, 21 Sep 2022 15:51:28 GMT
< 
* Connection #0 to host localhost left intact
<!DOCTYPE html><html><head><link rel="stylesheet" href="/index.c708214f.css"><meta http-equiv="Content-type" content="text/html; charset=utf-8"><title>Chronograf</title><link rel="icon shortcut" href="/favicon.70d63073.ico"></head><body> <div id="react-root" data-basepath=""></div> <script type="module" src="/index.e81b88ee.js"></script><script src="/index.a6955a67.js" nomodule="" defer></script> </body></html>
```

Вывод команды `curl http://localhost:9092/kapacitor/v1/ping -v`

```
*   Trying ::1:9092...
* Connected to localhost (::1) port 9092 (#0)
> GET /kapacitor/v1/ping HTTP/1.1
> Host: localhost:9092
> User-Agent: curl/7.74.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 204 No Content
< Content-Type: application/json; charset=utf-8
< Request-Id: 67ed0cfc-39c5-11ed-8070-0242ac130005
< X-Kapacitor-Version: 1.6.5
< Date: Wed, 21 Sep 2022 15:52:33 GMT
< 
* Connection #0 to host localhost left intact
```

Скриншот веб-интерфейса ПО:

![10_2_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_10_2/10_2_2.png)

4. Добавляем плагины `disk` и `mem` в `telegraf`, перезапускаем `telegraf`:

![10_2_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_10_2/10_2_3.png)

В ` Data Explorer` добавляем график утилизации оперативной памяти

![10_2_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_10_2/10_2_4.png)

Меняем группировку, интервал наблюдений и добавляем в новый дашбоард:

![10_2_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_10_2/10_2_5.png)

В ` Data Explorer` добавляем график утилизации места на диске, меняем группировку, интервал наблюдений и добавляем в новый дашбоард:

![10_2_6.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_10_2/10_2_6.png)

5. Добавляем плагины `docker` в `telegraf`, перезапускаем `telegraf`. К сожалению не удалось добиться появления плагина `docker`. Использовал несколько вариантов конфигурации `telegraf` и `docker-compose`, но в итоге плагин не появился.

Один из вариантов файлов касаемо добавления плагина `docker`:

#### telegraf.conf

```
[[inputs.docker]]
  endpoint = "unix:///var/run/docker.sock"
  container_names = []
  timeout = "5s"
  perdevice = true
  total = false
```

#### docker-compose.yml

```
  telegraf:
    # Full tag list: https://hub.docker.com/r/library/telegraf/tags/
    build:
      context: ./images/telegraf/
      dockerfile: ./${TYPE}/Dockerfile
      args:
        TELEGRAF_TAG: ${TELEGRAF_TAG}
    image: "telegraf"
    privileged: true
    environment:
      HOSTNAME: "telegraf-getting-started"
    # Telegraf requires network access to InfluxDB
    links:
      - influxdb
    ports:
      - "8092:8092/udp"
      - "8094:8094"
      - "8125:8125/udp"
    volumes:
      # Mount for telegraf configuration
      - ./telegraf/telegraf.conf:/etc/telegraf/telegraf.conf:Z
#      - ./telegraf/:/etc/telegraf/
      # Mount for Docker API access
      - /var/run/docker.sock:/var/run/docker.sock:Z
#      - /var/run/docker.sock:/var/run/docker.sock
    depends_on:
      - influxdb

```


## Дополнительное задание (со звездочкой*) - необязательно к выполнению

В веб-интерфейсе откройте вкладку `Dashboards`. Попробуйте создать свой dashboard с отображением:

    - утилизации ЦПУ
    - количества использованного RAM
    - утилизации пространства на дисках
    - аптайм
    
---
### Ответ:
---

    
Добавление метрик в новый дашбоард:

![10_2_7.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_10_2/10_2_7.png)
