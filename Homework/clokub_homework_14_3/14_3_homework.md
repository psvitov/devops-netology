# Домашнее задание к занятию "14.3 Карты конфигураций"

## Задача 1: Работа с картами конфигураций через утилиту kubectl в установленном minikube

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать карту конфигураций?

```
kubectl create configmap nginx-config --from-file=nginx.conf
kubectl create configmap domain --from-literal=name=netology.ru
```

### Как просмотреть список карт конфигураций?

```
kubectl get configmaps
kubectl get configmap
```

### Как просмотреть карту конфигурации?

```
kubectl get configmap nginx-config
kubectl describe configmap domain
```

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get configmap nginx-config -o yaml
kubectl get configmap domain -o json
```

### Как выгрузить карту конфигурации и сохранить его в файл?

```
kubectl get configmaps -o json > configmaps.json
kubectl get configmap nginx-config -o yaml > nginx-config.yml
```

### Как удалить карту конфигурации?

```
kubectl delete configmap nginx-config
```

### Как загрузить карту конфигурации из файла?

```
kubectl apply -f nginx-config.yml
```

---
### Ответ:
---

Возьмем за основу кластер Kubernetes, используемый в предыдущем модуле:

![14_3_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_3/14_3_1.png)

1. Создадим конфигурационный файл для nginx:

```
server {
  listen  80;
  server_name netology.ru www.netology.ru;
  access_log  /var/log/nginx/domains/netology-access.log main;
  error_log   /var/log/nginx/domains/netology-error.log info;
  location / {
    include proxy_params;
    proxy_pass  http://10.0.0.32:8080/;
    }
}
```
2. Создадим карту конфигураций из файла, из переменной, просмотрим список карт конфигураций и подробности созданных карт:

![14_3_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_3/14_3_2.png)

3. Получим информацию в формате `YAML` и `JSON`:

![14_3_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_3/14_3_3.png)

4. Выгрузим карту конфигурации и сохраним в файл:

![14_3_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_3/14_3_4.png)

5. Удалим карту конфигурации и восстановим из ранее созданного файла:

![14_3_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_3/14_3_5.png)

## Задача 2 (*): Работа с картами конфигураций внутри модуля

Выбрать любимый образ контейнера, подключить карты конфигураций и проверить
их доступность как в виде переменных окружения, так и в виде примонтированного
тома

---
### Ответ:
---

1. Создадим отдельное `namespace` для контейнера, установим его по умолчанию:

![14_3_6.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_3/14_3_6.png)

2. В новом `namespace` создадим карты конфигураций:

```
[root@master01 14_3]# kubectl create configmap nginx-config --from-file=nginx.conf
configmap/nginx-config created
[root@master01 14_3]# kubectl create configmap domain --from-literal=name=netology.ru
configmap/domain created
[root@master01 14_3]# kubectl get configmaps
NAME               DATA   AGE
domain             1      3s
kube-root-ca.crt   1      12m
nginx-config       1      14s
```

3. Развернем `POD` из манифеста с подключенной картой конфигурации в виде примонтированного тома:

```
apiVersion: v1
kind: Pod
metadata:
  name: front
spec:
  containers:
    - name: front-nginx
      image: nginx
      volumeMounts:
      - name: config-volume
        mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        name: nginx-config
```
Результат развертывания:

![14_3_7.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_3/14_3_7.png)

Результат проверки:

```
[root@master01 14_3]# kubectl exec -it front -- /bin/bash
root@front:/# cd /etc/config
root@front:/etc/config# ls -l
total 0
lrwxrwxrwx. 1 root root 17 Dec 27 17:12 nginx.conf -> ..data/nginx.conf
root@front:/etc/config# cat nginx.conf
server {
  listen  80;
  server_name netology.ru www.netology.ru;
  access_log  /var/log/nginx/domains/netology-access.log main;
  error_log   /var/log/nginx/domains/netology-error.log info;
  location / {
    include proxy_params;
    proxy_pass  http://10.0.0.32:8080/;
    }
}
```
4. Добавим в манифест карту конфигурации в виде переменной окружения:

```
apiVersion: v1
kind: Pod
metadata:
  name: front2
spec:
  containers:
    - name: front2-nginx
      image: nginx
      volumeMounts:
      - name: config-volume
        mountPath: /etc/config
      env:
        - name: SPECIAL_LEVEL_KEY
          valueFrom:
            configMapKeyRef:
              name: nginx-config
              key: nginx.conf
        - name: DOMAIN_KEY
          valueFrom:
            configMapKeyRef:
              name: domain
              key: name
  volumes:
    - name: config-volume
      configMap:
        name: nginx-config
        
````

Результат развертывания и проверки:

![14_3_8.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_3/14_3_8.png)
