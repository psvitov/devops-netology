# Домашнее задание к занятию "10.03. Grafana"

## Обязательные задания

### Задание 1
Используя директорию [help](./help) внутри данного домашнего задания - запустите связку prometheus-grafana.

Зайдите в веб-интерфейс графана, используя авторизационные данные, указанные в манифесте docker-compose.

Подключите поднятый вами prometheus как источник данных.

Решение домашнего задания - скриншот веб-интерфейса grafana со списком подключенных Datasource.

---
### Ответ:
---

1. Запускаем связку `prometheus-grafana`, заходим в веб-интерфейс:

![10_3_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_10_3/10_3_1.png)

![10_3_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_10_3/10_3_2.png)

2. Подключаем `prometheus` как источник данных, тестируем соединение:

![10_3_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_10_3/10_3_3.png)


## Задание 2
Изучите самостоятельно ресурсы:
- [promql-for-humans](https://timber.io/blog/promql-for-humans/#cpu-usage-by-instance)
- [understanding prometheus cpu metrics](https://www.robustperception.io/understanding-machine-cpu-usage)

Создайте Dashboard и в ней создайте следующие Panels:
- Утилизация CPU для nodeexporter (в процентах, 100-idle)
- CPULA 1/5/15
- Количество свободной оперативной памяти
- Количество места на файловой системе

Для решения данного ДЗ приведите promql запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.

---
### Ответ:
---

1. Создаем `Dashboard` и добавляем панели:

- Утилизация CPU

```
100 - (avg by (instance) (rate(node_cpu_seconds_total{job="nodeexporter",mode="idle"}[1m])) * 100) 
```

- CPULA 1/5/15

```
node_load1

node_load5

node_load15
```

- Количество свободной оперативной памяти

```
node_memory_Inactive_bytes/node_memory_MemAvailable_bytes*100
```

- Количество места на файловой системе

```
node_filesystem_avail_bytes{fstype!~"tmpfs|fuse.lxcfs|squashfs"} / node_filesystem_size_bytes{fstype!~"tmpfs|fuse.lxcfs|squashfs"}*100  
```

Скриншот получившегося `Dashboard` с добавленными панелями:

![10_3_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_10_3/10_3_4.png)



## Задание 3
Создайте для каждой Dashboard подходящее правило alert (можно обратиться к первой лекции в блоке "Мониторинг").

Для решения ДЗ - приведите скриншот вашей итоговой Dashboard.

---
### Ответ:
---

Создаем алерты для каждой панели:

![10_3_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_10_3/10_3_5.png)

![10_3_6.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_10_3/10_3_6.png)

![10_3_7.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_10_3/10_3_7.png)

![10_3_8.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_10_3/10_3_8.png)

Скриншот получившегося `Dashboard` с панелями и добавленными алертами:

![10_3_9.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_10_3/10_3_9.png)


## Задание 4
Сохраните ваш Dashboard.

Для этого перейдите в настройки Dashboard, выберите в боковом меню "JSON MODEL".

Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.

В решении задания - приведите листинг этого файла.

---
### Ответ:
---

Ссылка на листинг json-содержимого `Dashboard`: [dashboard.json](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_10_3/dashboard.json)
