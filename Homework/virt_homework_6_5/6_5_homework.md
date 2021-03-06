# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

### Ответ:
- текст Dockerfile манифеста: 
>   
    FROM centos:7
    ENV PATH=/usr/lib:$PATH
    #Добавляем пакет java
    RUN yum install java-1.8.0-openjdk-devel -y
    #Импортируем ключ
    RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
    #Создаем текстовый файл elasticsearch.repo
    RUN echo "[elasticsearch]" >>/etc/yum.repos.d/elasticsearch.repo &&\
       echo "name=Elasticsearch repository for 7.x packages" >>/etc/yum.repos.d/elasticsearch.repo &&\
       echo "baseurl=https://artifacts.elastic.co/packages/7.x/yum">>/etc/yum.repos.d/elasticsearch.repo &&\
       echo "gpgcheck=1">>/etc/yum.repos.d/elasticsearch.repo &&\
       echo "gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch">>/etc/yum.repos.d/elasticsearch.repo &&\
       echo "enabled=0">>/etc/yum.repos.d/elasticsearch.repo &&\
       echo "autorefresh=1">>/etc/yum.repos.d/elasticsearch.repo &&\
       echo "type=rpm-md">>/etc/yum.repos.d/elasticsearch.repo
    #Устанавливаем Elastic
    RUN yum install -y --enablerepo=elasticsearch elasticsearch
    #Настраиваем каталоги
    RUN mkdir /usr/share/elasticsearch/snapshots &&\
       chown elasticsearch:elasticsearch /usr/share/elasticsearch/snapshots
    RUN mkdir /var/lib/logs \
       && chown elasticsearch:elasticsearch /var/lib/logs \
       && mkdir /var/lib/data \
       && chown elasticsearch:elasticsearch /var/lib/data
    USER elasticsearch
    CMD ["/usr/sbin/init"]
    CMD ["/usr/share/elasticsearch/bin/elasticsearch"]
- ссылка на образ в репозитории dockerhub: `https://hub.docker.com/r/psvitov/elastic`
- ответ `elasticsearch` на запрос пути `/` в json виде: [elastic.json](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_6_5/elastic.json)

## Задача 2

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

### Ответ: 

- Добавление индексов в `elasticsearch`:

> 
    bash-4.2$ curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d' {"settings": {"number_of_shards": 1, "number_of_replicas": 0}}'
    bash-4.2$ curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d' {"settings": {"number_of_shards": 2, "number_of_replicas": 1}}'
    bash-4.2$ curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d' {"settings": {"number_of_shards": 4, "number_of_replicas": 2}}'
    
- Получение списка индексов:

>   
    bash-4.2$ curl 'localhost:9200/_cat/indices?v&pretty'
    
![скрин 6_5_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_6_5/6_5_1.png)
 
- Статус индекса ind-1:

>   
    bash-4.2$ curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
    {
     "cluster_name" : "elasticsearch",
     "status" : "green",
     "timed_out" : false,
     "number_of_nodes" : 1,
     "number_of_data_nodes" : 1,
     "active_primary_shards" : 1,
     "active_shards" : 1,
     "relocating_shards" : 0,
     "initializing_shards" : 0,
     "unassigned_shards" : 0,
     "delayed_unassigned_shards" : 0,
     "number_of_pending_tasks" : 0,
     "number_of_in_flight_fetch" : 0,
     "task_max_waiting_in_queue_millis" : 0,
     "active_shards_percent_as_number" : 100.0
    }
    
- Статус индекса ind-2:

>   
    bash-4.2$ curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'
    {
     "cluster_name" : "elasticsearch",
     "status" : "yellow",
     "timed_out" : false,
     "number_of_nodes" : 1,
     "number_of_data_nodes" : 1,
     "active_primary_shards" : 2,
     "active_shards" : 2,
     "relocating_shards" : 0,
     "initializing_shards" : 0,
     "unassigned_shards" : 2,
     "delayed_unassigned_shards" : 0,
     "number_of_pending_tasks" : 0,
     "number_of_in_flight_fetch" : 0,
     "task_max_waiting_in_queue_millis" : 0,
     "active_shards_percent_as_number" : 50.0
    }

- Статус индекса ind-3:

>   
    bash-4.2$ curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty'
    {
     "cluster_name" : "elasticsearch",
     "status" : "yellow",
     "timed_out" : false,
     "number_of_nodes" : 1,
     "number_of_data_nodes" : 1,
     "active_primary_shards" : 4,
     "active_shards" : 4,
     "relocating_shards" : 0,
     "initializing_shards" : 0,
     "unassigned_shards" : 8,
     "delayed_unassigned_shards" : 0,
     "number_of_pending_tasks" : 0,
     "number_of_in_flight_fetch" : 0,
     "task_max_waiting_in_queue_millis" : 0,
     "active_shards_percent_as_number" : 50.0
    }

- Статус кластера:

>   
    bash-4.2$ curl -XGET localhost:9200/_cluster/health/?pretty=true
    {
     "cluster_name" : "elasticsearch",
     "status" : "yellow",
     "timed_out" : false,
     "number_of_nodes" : 1,
     "number_of_data_nodes" : 1,
     "active_primary_shards" : 10,
     "active_shards" : 10,
     "relocating_shards" : 0,
     "initializing_shards" : 0,
     "unassigned_shards" : 10,
     "delayed_unassigned_shards" : 0,
     "number_of_pending_tasks" : 0,
     "number_of_in_flight_fetch" : 0,
     "task_max_waiting_in_queue_millis" : 0,
     "active_shards_percent_as_number" : 50.0
    }

- Состояние кластера: 
>   
    "status" : "yellow",

Часть индексов и сам кластер находится в состоянии `yellow`, так как не хватает нод для полноценной работы самого кластера.

- Удаление индексов: 

>
    bash-4.2$ curl -X DELETE 'http://localhost:9200/ind-1?pretty'
    {
     "acknowledged" : true
    }
    bash-4.2$ curl -X DELETE 'http://localhost:9200/ind-2?pretty'
    {
      "acknowledged" : true
    }
    bash-4.2$ curl -X DELETE 'http://localhost:9200/ind-3?pretty'
    {
      "acknowledged" : true
    }
    bash-4.2$ curl 'localhost:9200/_cat/indices?v&pretty'
    health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   .geoip_databases yfManuTdQBezMAF1ob_ABw   1   0         40            0     37.9mb         37.9mb
    bash-4.2$ 



## Задача 3

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

### Ответ:

Проведена доработка `elasticsearch.yml`: добавлена строчка: 
>   
    path.repo: [ "/usr/share/elasticsearch/snapshots" ]

- Создаем директорию как `snapshot repository` c именем `netology_backup`:

> 
    bash-4.2$ curl -XPOST localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -     d'{"type": "fs", "settings": { "location":"/usr/share/elasticsearch/snapshots" }}'
    {
      "acknowledged" : true
    }
    
- Результат:

> 
    bash-4.2$ curl http://localhost:9200/_snapshot/netology_backup?pretty
    {
      "netology_backup" : {
        "type" : "fs",
       "settings" : {
          "location" : "/usr/share/elasticsearch/snapshots"
       }
      }
    }
    
- Создаем индекс `test`:

> 
    bash-4.2$ curl -X PUT localhost:9200/test -H 'Content-Type: application/json' -d'{ "settings": {    "number_of_shards": 1,  "number_of_replicas": 0 }}'
    {"acknowledged":true,"shards_acknowledged":true,"index":"test"}
   
- Список индексов:

> 
    bash-4.2$ curl -X GET 'http://localhost:9200/_cat/indices?v'
    health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   .geoip_databases Z1MrdX1CRzKmgLGvF82wKA   1   0         40            0       38mb           38mb
    green  open   test             gfJzT3e_SRePncNzaaZ8Kg   1   0          0            0       226b           226b 
    
- Создание снапшота:

> 
    bash-4.2$ curl -X PUT localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true
    {"snapshot":        {"snapshot":"elasticsearch","uuid":"n1Rr6vT5RDqd3Nqj0c3ziA","repository":"netology_backup","version_id":7170599,"ve rsion":"7.17.5","indices":[".ds-.logs-deprecation.elasticsearch-default-2022.06.29-000001",".ds-ilm-history-5-  2022.06.29-000001","test",".geoip_databases"],"data_streams":["ilm-history-5",".logs-deprecation.elasticsearch- default"],"include_global_state":true,"state":"SUCCESS","start_time":"2022-06-  29T18:00:26.514Z","start_time_in_millis":1656525626514,"end_time":"2022-06- 29T18:00:28.115Z","end_time_in_millis":1656525628115,"duration_in_millis":1601,"failures":[],"shards":{"total":4,"failed":0,"successful":4},"feature_states":[{"feature_name":"geoip","indices":[".geoip_databases"]}]}}  
    
![скрин 6_5_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_6_5/6_5_2.png)

- Удаление индекса `test` и создание индекса `test-2`

> 
    bash-4.2$ curl -X DELETE 'http://localhost:9200/test?pretty'
    {
      "acknowledged" : true
    }
    bash-4.2$ curl -X PUT localhost:9200/test-2 -H 'Content-Type: application/json' -d'{ "settings": {  "number_of_shards": 1,  "number_of_replicas": 0 }}'
    bash-4.2$ curl -X GET 'http://localhost:9200/_cat/indices?v'
    health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   .geoip_databases Z1MrdX1CRzKmgLGvF82wKA   1   0         40            0       38mb           38mb
    green  open   test-2           ZUyT0xXoQgWfYy1D7QEJyA   1   0          0            0       226b           226b
    bash-4.2$ 

- Восстановление из снапшота:

> 
    bash-4.2$ curl -X POST localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty -H 'Content-Type:     application/json' -d'{"include_global_state":true}'
    {
      "accepted" : true
    }

- Список индексов:

>   
    bash-4.2$ curl -X GET 'http://localhost:9200/_cat/indices?v'
    health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   .geoip_databases Z1MrdX1CRzKmgLGvF82wKA   1   0         40            0       38mb           38mb
    green  open   test             JaQUZ8PZRoau4F5JTv7BFg   1   0          0            0       226b           226b
    green  open   test-2           Bk6-egs6TQaKqR96oLpbOg   1   0          0            0       226b           226b
    bash-4.2$ 



    
