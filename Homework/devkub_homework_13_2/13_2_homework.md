# Домашнее задание к занятию "13.2 разделы и монтирование"

Предварительная подготовка произведена:

![13_2_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_2/13_2_1.png)


## Задание 1: подключить для тестового конфига общую папку
В stage окружении часто возникает необходимость отдавать статику бекенда сразу фронтом. Проще всего сделать это через общую папку. Требования:
* в поде подключена общая папка между контейнерами (например, /static);
* после записи чего-либо в контейнере с беком файлы можно получить из контейнера с фронтом.

---
### Ответ:
---

1. Создаем `pod` с 2-мя контейнерами `frontend-nginx` и `backend-nginx`:

![13_2_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_2/13_2_2.png)

2. Создадим и запишем данные в файл на контейнере `frontend-nginx`:

```
kubectl exec stage-vol -c frontend-nginx -- sh -c 'echo "Netology Kubernetes TEST" > /tmp/cache/volume_test.txt'
```

3. Прочитаем данные из каталога и файла на контейнере `backend-nginx`:

```
kubectl exec stage-vol -c backend-nginx -- ls -la /tmp/static
kubectl exec stage-vol -c backend-nginx -- sh -c 'cat /tmp/static/volume_test.txt'
```

4. Результат проверки:

![13_2_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_2/13_2_3.png)

5. Ссылка на манифест: [stage-volume.yml](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_2/stage-volume.yml)

## Задание 2: подключить общую папку для прода
Поработав на stage, доработки нужно отправить на прод. В продуктиве у нас контейнеры крутятся в разных подах, поэтому потребуется PV и связь через PVC. Сам PV должен быть связан с NFS сервером. Требования:
* все бекенды подключаются к одному PV в режиме ReadWriteMany;
* фронтенды тоже подключаются к этому же PV с таким же режимом;
* файлы, созданные бекендом, должны быть доступны фронту.

---
### Ответ:
---

1. Создадим `pvc`:

![13_2_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_2/13_2_4.png)

2. Создадим поды для `frontend` и `backend`:

![13_2_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_2/13_2_5.png)

3. Создадим и запишем данные в файл на поде `backend`:

```
kubectl exec prod-b-d76d676f8-vztsg -- sh -c 'echo "Netology Kubernetes PVC TEST" > /mnt/nfs/pvc_test.txt'
```

4. Прочитаем данные из каталога и файла на поде `frontend`:

```
kubectl exec prod-f-76b85b7dbc-nj22h -- ls -la /mnt/nfs
kubectl exec prod-f-76b85b7dbc-nj22h -- sh -c 'cat /mnt/nfs/pvc_test.txt'
```

5. Результат проверки:

![13_2_6.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_2/13_2_6.png)

6. Ссылки на манифесты:
- [prod-pvc.yml](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_2/prod-pvc.yml)
- [prod-front.yml](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_2/prod-front.yml)
- [prod-back.yml](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_2/prod-back.yml)


