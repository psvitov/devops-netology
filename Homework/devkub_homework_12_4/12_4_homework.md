# Домашнее задание к занятию "12.4 Развертывание кластера на собственных серверах, лекция 2"
Новые проекты пошли стабильным потоком. Каждый проект требует себе несколько кластеров: под тесты и продуктив. Делать все руками — не вариант, поэтому стоит автоматизировать подготовку новых кластеров.

## Задание 1: Подготовить инвентарь kubespray
Новые тестовые кластеры требуют типичных простых настроек. Нужно подготовить инвентарь и проверить его работу. Требования к инвентарю:
* подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды;
* в качестве CRI — containerd;
* запуск etcd производить на мастере.

---
### Ответ:
---

1. Создадим 5 ВМ на `Yandex.Cloud` - 1 мастер нода и 4 рабочих ноды:

![12_4_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_12_4/12_4_1.png)

2. Проведем предварительную настройку всех ВМ:

- создадим на мастер-ноде ключ ssh  и скопируем его на все рабочие ноды;
- на мастер-ноде установим `pip`, `git` и скопируем репозиторий `kubespray`;
- устанавливаем все зависимости из файла `requirements.txt`

3. Настраиваем `inventory.ini` для подготовки кластера:

![12_4_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_12_4/12_4_2.png)

4. Вносим изменения в файлы конфигурации кластера:

`group_vars/k8s_cluster/k8s-cluster.yml`:

```
cluster_name: ru-central1.internal
container_manager: containerd
```
5. Запуск `kubespray`:

`ansible-playbook -u root -i ~/k8s/inventory/sample/inventory.ini cluster.yml -b --diff`

Результат работы:

![12_4_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/devkub_homework_12_4/12_4_3.png)
