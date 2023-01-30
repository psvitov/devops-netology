# Домашнее задание к занятию "14.5 SecurityContext, NetworkPolicies"

## Задача 1: Рассмотрите пример 14.5/example-security-context.yml

Создайте модуль

```
kubectl apply -f 14.5/example-security-context.yml
```

Проверьте установленные настройки внутри контейнера

```
kubectl logs security-context-demo
uid=1000 gid=3000 groups=3000
```

---
### Ответ: 
---

1. Возьмем за основу кластер Kubernetes, используемый в предыдущем модуле:

![14_5_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_5/14_5_1.png)

2. Создадим каталог и поместим файл `example-security-context.yml` с содержимым:

```
---
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo
spec:
  containers:
  - name: sec-ctx-demo
    image: fedora:latest
    command: [ "id" ]
    securityContext:
      runAsUser: 1000
      runAsGroup: 3000
```

3. Создадим модуль:

![14_5_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_5/14_5_2.png)




