# Домашнее задание к занятию "14.1 Создание и использование секретов"

## Задача 1: Работа с секретами через утилиту kubectl в установленном minikube

Выполните приведённые ниже команды в консоли, получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать секрет?

```
openssl genrsa -out cert.key 4096
openssl req -x509 -new -key cert.key -days 3650 -out cert.crt \
-subj '/C=RU/ST=Moscow/L=Moscow/CN=server.local'
kubectl create secret tls domain-cert --cert=certs/cert.crt --key=certs/cert.key
```

### Как просмотреть список секретов?

```
kubectl get secrets
kubectl get secret
```

### Как просмотреть секрет?

```
kubectl get secret domain-cert
kubectl describe secret domain-cert
```

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get secret domain-cert -o yaml
kubectl get secret domain-cert -o json
```

### Как выгрузить секрет и сохранить его в файл?

```
kubectl get secrets -o json > secrets.json
kubectl get secret domain-cert -o yaml > domain-cert.yml
```

### Как удалить секрет?

```
kubectl delete secret domain-cert
```

### Как загрузить секрет из файла?

```
kubectl apply -f domain-cert.yml
```

---
### Ответ:
---

Возьмем за основу кластер `Kubernetes`, используемый в предыдущем модуле:

![14_1_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_1/14_1_1.png)

1. Создадим секрет, посмотрим список созданных секретов, созданный секрет и его подробности:

![14_1_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_1/14_1_2.png)

2. Получим информацию в форматах `YAML` и `JSON`:

![14_1_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_1/14_1_3.png)

3. Выгрузим секрет в файлы форматов `YAML` и `JSON`:

![14_1_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_1/14_1_4.png)

4. Удалим секрет и восстановим из  форматов `YAML` и `JSON`:

![14_1_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_1/14_1_5.png)



## Задача 2: Работа с секретами внутри модуля

Выберите любимый образ контейнера, подключите секреты и проверьте их доступность
как в виде переменных окружения, так и в виде примонтированного тома.

---
### Ответ:
---

1. Создадим отдельное `namespace` для контейнера, установим его по умолчанию:

![14_1_6.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_1/14_1_6.png)

2. Создадим секрет в новом `namespace`:

![14_1_7.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_1/14_1_7.png)

3. Развернем `pod` из манифеста с подключенным секретом в виде примонтированного тома: 

```
---
apiVersion: v1
kind: Pod
metadata:
  name: front
spec:
  containers:
  - name: front-nginx
    image: nginx
    volumeMounts:
    - name: secret
      mountPath: "/home/devops/14_1/certs"
      readOnly: true
  volumes:
  - name: secret
    secret:
      secretName: domain-cert
```

![14_1_8.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_1/14_1_8.png)

Подключимся к поду и проверим:

```
[root@master01 14_1]# kubectl exec -it front -- /bin/bash
root@front:/# cd /var/run/secrets
root@front:/var/run/secrets# ls -la
total 0
drwxr-xr-x. 3 root root 27 Dec 19 16:58 .
drwxr-xr-x. 1 root root 38 Dec 19 16:58 ..
drwxr-xr-x. 3 root root 28 Dec 19 16:58 kubernetes.io
root@front:/var/run/secrets#
```

4. Создадим на основе пердыдущего манифеста новый манифест, но добавив секрет в виде переменных окружения:

```
---
apiVersion: v1
kind: Pod
metadata:
  name: front2
spec:
  containers:
  - name: front2-nginx
    image: nginx
    env:
    - name: SECRET_USERNAME
      value: "netology_admin"
    - name: SECRET_PASSWORD
      value: "P@ssw0rd!"
    volumeMounts:
    - name: secret
      mountPath: "/home/devops/14_1/certs"
      readOnly: true
  volumes:
  - name: secret
    secret:
      secretName: domain-cert
```

5. Результат:

![14_1_9.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_1/14_1_9.png)

![14_1_10.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_1/14_1_10.png)


