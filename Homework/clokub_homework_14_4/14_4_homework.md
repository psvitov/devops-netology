# Домашнее задание к занятию "14.4 Сервис-аккаунты"

## Задача 1: Работа с сервис-аккаунтами через утилиту kubectl в установленном minikube

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать сервис-аккаунт?

```
kubectl create serviceaccount netology
```

### Как просмотреть список сервис-акаунтов?

```
kubectl get serviceaccounts
kubectl get serviceaccount
```

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get serviceaccount netology -o yaml
kubectl get serviceaccount default -o json
```

### Как выгрузить сервис-акаунты и сохранить его в файл?

```
kubectl get serviceaccounts -o json > serviceaccounts.json
kubectl get serviceaccount netology -o yaml > netology.yml
```

### Как удалить сервис-акаунт?

```
kubectl delete serviceaccount netology
```

### Как загрузить сервис-акаунт из файла?

```
kubectl apply -f netology.yml
```

---
### Ответ:
---

1. Возьмем за основу кластер Kubernetes, используемый в предыдущем модуле:

![14_4_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_4/14_4_1.png)

2. Создадим сервис-аккаунт и просмотрим список всех сервис-аккаунтов:

![14_4_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_4/14_4_2.png)

3. Получим информацию о сервис-аккаунтах в формате `YAML` и `JSON`:

![14_4_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_4/14_4_3.png)

4. Выгрузим сервис-акаунты в файлы `YAML` и `JSON`:

![14_4_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_4/14_4_4.png)
![14_4_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_4/14_4_5.png)

5. Удалим сервис-аккаунт и восстановим его из сохраненного файла:

![14_4_6.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_4/14_4_6.png)




