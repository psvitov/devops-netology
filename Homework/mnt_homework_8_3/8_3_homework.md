# Домашнее задание к занятию "08.03 Использование Yandex Cloud"

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.

Ссылка на репозиторий LightHouse: https://github.com/VKCOM/lighthouse

---
### Ответ:
---

Подготовлены 3 ВМ на `Yandex Cloud`:

![8_3_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_3/8_3_1.PNG)

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает lighthouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику lighthouse, установить nginx или любой другой webserver, настроить его конфиг для открытия lighthouse, запустить webserver.
4. Приготовьте свой собственный inventory файл `prod.yml`.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---
### Ответ:
---

1. Добавляем в `playbook` новый `play`:

> 
    ---
    - name: Install Lighthouse
      hosts: lighthouse
      tasks:
        - name: Install EPEL
          become: true
          ansible.builtin.yum:
            name: "epel-release"
            state: latest
        - name: Install Nginx & Git
          become: true
          ansible.builtin.yum:
            name:
              - nginx
              - git
            state: latest
        - name: Start Nginx
          become: true
          ansible.builtin.systemd:
            name: nginx
            state: started
        - name: Autorun Nginx
          become: true
          ansible.builtin.systemd:
            name: nginx
            enabled: yes
        - name: Install FireWall
          become: true
          ansible.builtin.yum:
            name: "firewalld"
            state: latest
        - name: Start FireWall
          become: true
          ansible.builtin.systemd:
            name: firewalld
            state: started
        - name: Upgrade FireWall
          become: true
          ansible.builtin.command:
            cmd: "{{ item }}"
          with_items:
            - firewall-cmd --zone=public --permanent --add-service=http
            - firewall-cmd --zone=public --permanent --add-service=https
            - firewall-cmd --reload
        - name: Create directory
          become: true
          ansible.builtin.file:
            path: /var/www/lighthouse
            state: directory
            owner: nginx
            group: nginx
            mode: "0755"
        - name: Clone repository Lighthouse
          become: true
          ansible.builtin.command:
            cmd: "{{ item }}"
          with_items:
            - git clone https://github.com/VKCOM/lighthouse.git /usr/share/nginx/lighthouse
            - sed -i 's|/usr/share/nginx/html|/usr/share/nginx/lighthouse|' /etc/nginx/nginx.conf
        - name: Restart Nginx
          ansible.builtin.systemd:
            name: nginx
            state: restarted
            
Данный `play`:
- устанавливает репозиторий `EPEL`;
- устанавливает nginx и git;
- стартует nginx и добавляет его в автозагрузку;
- устанавливаем  и стартуем FireWall;
- Настраиваем FireWall;
- создаем директорию, где будет находиться lighthouse;
- клонируем репозиторий в созданную папку и меняем путь в nginx.conf где у нас находится lighthouse;
- рестартуем nginx

2. Файл `prod.yml`:

>
    ---
    clickhouse:
      hosts:
        srv-clickhouse:
          ansible_host: 51.250.107.1
    vector:
      hosts:
        srv-vector:
          ansible_host: 84.201.154.105
    lighthouse:
      hosts:
        srv-lighthouse:
          ansible_host: 84.201.179.38
          
3. Проверяем `site.yml` на ошибки:

![8_3_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_3/8_3_2.PNG)

4. Запускаем `playbook` с флагом `--check`:

![8_3_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_3/8_3_3.PNG)

5. Запускаем `playbook` с флагом `--diff`:

![8_3_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_3/8_3_4.PNG)
![8_3_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_3/8_3_5.PNG)
![8_3_6.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_3/8_3_6.PNG)

По какой-то причине не рестартовал nginx

6. Повторно запускаем `playbook` с флагом `--diff`:

![8_3_7.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_3/8_3_7.PNG)
![8_3_8.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_3/8_3_8.PNG)

Ошибка клонирования lighthouse после повторного запуска вызвана тем,, что при первом запуске файлы уже были скопированы

7. Проверяем работу lighthouse:

![8_3_9.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_8_3/8_3_9.PNG)

8. Ссылка на репозиторий ДЗ: [mnt_homework_8_3](https://github.com/psvitov/mnt_homework_8_3)
