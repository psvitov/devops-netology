# Домашнее задание к занятию "13.1 контейнеры, поды, deployment, statefulset, services, endpoints"
Настроив кластер, подготовьте приложение к запуску в нём. Приложение стандартное: бекенд, фронтенд, база данных. Его можно найти в папке 13-kubernetes-config.

Подготовим кластер `Kubernetes`:

![13_1_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_1/13_1_1.png)

## Задание 1: подготовить тестовый конфиг для запуска приложения
Для начала следует подготовить запуск приложения в stage окружении с простыми настройками. Требования:
* под содержит в себе 2 контейнера — фронтенд, бекенд;
* регулируется с помощью deployment фронтенд и бекенд;
* база данных — через statefulset.

---
### Ответ:
---

1. Создаем `pod` с 2-мя контейнерами с помощью `k8s-stage.yml`:

```
# Configure Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: k8s-stage
  labels:
    app: k8s-app
spec:
  selector:
    matchLabels:
      app: k8s-app
  template:
    metadata:
      labels:
        app: k8s-app
    spec:
    # Configure Pod
      containers:
      - name: frontend
        image: nginx:1.14.2
        ports:
        - containerPort: 80
      - name: backend
        image: centos7
        command: ["sleep", "50000"]
---
# Configure Service
apiVersion: v1
kind: Service
metadata:
  name: k8s-svc
  labels:
    app: k8s
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 8000
  selector:
    app: k8s
[root@master-host kubespray]#
```

2. Создаем `statefulset` через `k8s-psql.yml`:

```
# Configure PostgreSQL StatefulSet
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: psql-db
spec:
  serviceName: psql-db-svc
  selector:
    matchLabels:
      app: psql-db
  replicas: 1
  template:
    metadata:
      labels:
	app: psql-db
    spec:
      containers:
        - name: psql-sdb
          image: postgres:13-alpine
          volumeMounts:
            - name: psql-db-disk
              mountPath: /data
          env:
            - name: POSTGRES_PASSWORD
              value: postgres
            - name: PGDATA
              value: /data/pgdata
  # Configure Volume Claim
  volumeClaimTemplates:
    - metadata:
        name: psql-db-disk
      spec:
	accessModes: ["ReadWriteMany"]
        resources:
          requests:
            storage: 1Gi
---
# Configure PostgreSQL StatefulSet Service
apiVersion: v1
kind: Service
metadata:
  name: psql-db-lb
spec:
  selector:
    app: psql-db
  type: LoadBalancer
  ports:
    - port: 5432
# Config PersistentVolume (pv)
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-pv
  labels:
    type: local
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  nfs:
    server: 10.0.0.32
    path: /home/nfs
```

3. 





## Задание 2: подготовить конфиг для production окружения
Следующим шагом будет запуск приложения в production окружении. Требования сложнее:
* каждый компонент (база, бекенд, фронтенд) запускаются в своем поде, регулируются отдельными deployment’ами;
* для связи используются service (у каждого компонента свой);
* в окружении фронта прописан адрес сервиса бекенда;
* в окружении бекенда прописан адрес сервиса базы данных.

---
### Ответ:
---

## Задание 3 (*): добавить endpoint на внешний ресурс api
Приложению потребовалось внешнее api, и для его использования лучше добавить endpoint в кластер, направленный на это api. Требования:
* добавлен endpoint до внешнего api (например, геокодер).
---
### Ответ:
---

