# Домашнее задание к занятию "08.02 Работа с Playbook"

## Подготовка к выполнению

1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

---
### Ответ:
---

1. Видео изучены.

2. Ссылка на новый публичный репозиторий: [mnt_homework_8_2](https://github.com/psvitov/mnt_homework_8_2)

3. `Playbook` помещен в репозиторий:

![8_2_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_2/8_2_1.png)

4. Хосты подготовлены на `Yandex Cloud`:

![8_2_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_2/8_2_2.png)


## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---
### Ответ:
---

1. формируем файл `inventory/prod.yml`:

> 
    ---
    clickhouse:
      hosts:
        srv-clickhouse:
          ansible_host: 51.250.92.85
    vector:
      hosts:
        srv-vector:
          ansible_host: 51.250.90.71
          
2. Добавляем в `playbook` еще один `play` для установки `Vector`:

> 
    - name: Install Vector
      hosts: vector
      tasks:
        - name: Download Vector
          ansible.builtin.get_url:
            url: "https://packages.timber.io/vector/0.21.0/vector-0.21.0-1.x86_64.rpm"
            dest: "./vector-0.21.0-1.x86_64.rpm"
        - name: Install Vector
          become: true
          ansible.builtin.yum:
            name: "vector-0.21.0-1.x86_64.rpm"

3. Запускаем `ansible-lint site.yml` с ключом `-v`:

![8_2_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_2/8_2_3.png)

Ошибок не обнаружено.

4. Запуск `playbook` с флагом `--check`:

![8_2_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_2/8_2_4.png)


5. Запуск `playbook` на `prod.yml` окружении с флагом `--diff`:

[First diff](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_2/8_2_diff)

6. Повторный playbook с флагом --diff:

[Second diff](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_2/8_2_2diff)

7. Ссылка на фиксирующий [`коммит`](https://github.com/psvitov/mnt_homework_8_2) 
