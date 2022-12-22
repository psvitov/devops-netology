# Домашнее задание к занятию "14.2 Синхронизация секретов с внешними сервисами. Vault"

## Задача 1: Работа с модулем Vault

Запустить модуль Vault конфигураций через утилиту kubectl в установленном minikube

```
kubectl apply -f 14.2/vault-pod.yml
```

Получить значение внутреннего IP пода

```
kubectl get pod 14.2-netology-vault -o json | jq -c '.status.podIPs'
```

Примечание: jq - утилита для работы с JSON в командной строке

Запустить второй модуль для использования в качестве клиента

```
kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
```

Установить дополнительные пакеты

```
dnf -y install pip
pip install hvac
```

Запустить интепретатор Python и выполнить следующий код, предварительно
поменяв IP и токен

```
import hvac
client = hvac.Client(
    url='http://10.10.133.71:8200',
    token='aiphohTaa0eeHei'
)
client.is_authenticated()

# Пишем секрет
client.secrets.kv.v2.create_or_update_secret(
    path='hvac',
    secret=dict(netology='Big secret!!!'),
)

# Читаем секрет
client.secrets.kv.v2.read_secret_version(
    path='hvac',
)
```

---
### Ответ:
---

Возьмем за основу кластер Kubernetes, используемый в предыдущем модуле:

![14_2_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_2/14_2_1.png)

1. Создаем отдельный каталог `14_2`, копируем туда файл `vault-pod.yml`, запускаем командой `kubectl apply -f vault-pod.yml`, проверяем созданный `pod`:

![14_2_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_2/14_2_2.png)

2. Получаем внутренний IP-адрес пода, запускаем второй модуль и устанавливаем `pip`:

![14_2_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_2/14_2_3.png)

3. Устанавливаем `hvac`:
![14_2_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_2/14_2_4.png)

4. Запустим в интерпретаторе `python3` измененный код:

```
import hvac
client = hvac.Client(
    url='http://10.233.126.69:8200',
    token='aiphohTaa0eeHei'
)
client.is_authenticated()

client.secrets.kv.v2.create_or_update_secret(
    path='hvac',
    secret=dict(netology='Big secret!!!'),
)

client.secrets.kv.v2.read_secret_version(
    path='hvac',
)
```

![14_2_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/clokub_homework_14_2/14_2_5.png)

