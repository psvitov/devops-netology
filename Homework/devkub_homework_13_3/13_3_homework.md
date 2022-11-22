# Домашнее задание к занятию "13.3 работа с kubectl"

## Задание 1: проверить работоспособность каждого компонента
Для проверки работы можно использовать 2 способа: port-forward и exec. Используя оба способа, проверьте каждый компонент:
* сделайте запросы к бекенду;
* сделайте запросы к фронту;
* подключитесь к базе данных.

---
### Ответ:
---

Воспользуемся предыдущим ДЗ с созданными ресурсами:

![13_3_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_3/13_3_1.png)

1. Применим `port-forward` к фронтенду:

```
[root@master-host devops]# kubectl port-forward deployment/prod-f :80
Forwarding from 127.0.0.1:46036 -> 80
Forwarding from [::1]:46036 -> 80
```

2. Запрос:

![13_3_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_3/13_3_2.png)


3. Ответ:

![13_3_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_3/13_3_3.png)

4. Применим `port-forward` к бекэнду:

```
[root@master-host devops]# kubectl port-forward deployment/prod-b :8080
Forwarding from 127.0.0.1:36625 -> 8080
Forwarding from [::1]:36625 -> 8080
```

5. Так как в качестве бекэнда использовался образ `busybox`, в нем нет `nginx` запросы `curl` и `wget` отваливаются с ошибками, но сами запросы перенаправляются:

6. Запрос:

![13_3_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_3/13_3_4.png)


7. Ответ:

![13_3_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_3/13_3_5.png)



## Задание 2: ручное масштабирование

При работе с приложением иногда может потребоваться вручную добавить пару копий. Используя команду kubectl scale, попробуйте увеличить количество бекенда и фронта до 3. Проверьте, на каких нодах оказались копии после каждого действия (kubectl describe, kubectl get pods -o wide). После уменьшите количество копий до 1.

---
### Ответ:
---

1. Увелиим количество подов бекенда до 5, фронтенда до 3-х:

![13_3_6.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_3/13_3_6.png)

![13_3_61.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_3/13_3_61.png)

![13_3_62.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_3/13_3_62.png)


2. Так как в кластере используется всего одна нода, то все поды оказались на `node-01`:

![13_3_7.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_3/13_3_7.png)

3. Уменьшаем количество подов бекенда и фронтенда до 1:

![13_3_8.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_13_3/13_3_8.png)





