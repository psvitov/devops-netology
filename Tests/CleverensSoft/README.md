### ТЕСТОВОЕ ЗАДАНИЕ

1. Скачать архив:
https://disk.yandex.ru/d/Axk-aI_RdBPizg
2. Прокомментировать файл, пояснив какая часть за что отвечает
3. Создать в архиве файл README.md
4. Написать новую роль, которая открывает порты (22, 80, 443) на виртуальном сервере test1(операционная система Ubuntu, файервол ufw)
5. Описать в файле README.md для чего нужен и что делает каждый файл архива, написать рекомендации или ошибки
6. Описать в файле README.md что будет результатом выполнения задачи general_deploy_job из файла .gitlab-ci.yml

Прислать результат в виде архива на почту hr@cleverence.ru обязательно указав ФИО, название вакансии и прикрепить резюме в формате PDF.

### РЕШЕНИЕ:

1. Содержимое архива:

В архиве находятся файлы манифеста Ansible:

- файл `hosts` содержит описание хостов, разделенных на 2 группы: `[allservers]` и `[cloud_client]`
- файл `initial_user.yml` создает на серверах пользователя `superuser`, запись в файл `sudoers` и копирует ключ авторизации
- файл `master.yml` запускает выполнение ролей, описанных в папке roles: 

  moscow_region - установка таймзоны Europe/Moscow на всех хостах;
  
  community.zabbix.zabbix_agent - подгружаемая из Ansible Galaxy роль zabbix_agent для установки zabbix-агента и привязки его к серверу мониторинга
  
  cron_copy_files - копирование скрипта и добавление его в планировщик cron

- файл `requirements.yml`содержит описание подключаемых коллекций и ролей из Ansible Galaxy
- файл `.gitlab-ci.yml` содержит описание пайплайна для GitLab CI, описаны задачи создания образа и его заливка на DockerHub, запуск плейбука для создания пользователя и деплой сборки
- папка `build` содержит файл `Dockerfile` для сборки образа
- папка `roles` содержит роли 

2. Добавление роли:

Создадим в папке `roles` папку `setting_ufw` для новой роли и в ней создадим файл `main.yml` с содержимым:

```
---
# tasks file

- name: Install ufw
  ansible.builtin.apt:
    name: ufw
    state: present

- name: Settings default policy
  ansible.builtin.command: "{{ item }}"
  with_items:
    - ufw default deny incoming
    - ufw default allow outgoing

- name: Permission connections
  ansible.builtin.command: "{{ item }}"
  with_items:
    - ufw allow ssh
    - ufw allow http
    - ufw allow https

- name: Enable ufw
  ansible.builtin.command:
  argv:
    - ufw enable
    - -y
```

Добавим роль в файл `master.yml`:

```
- hosts: cloud_client
  become: true
  gather_facts: true
  roles:
    - role: cron_copy_files
    - role: setting_ufw
```

3. Результат выполнения задачи general_deploy_job:

Запустится задача `.deploy_abstr`, которая на основании созданного образа Docker с Ansible скачает необходимые коллекции согласно файла requirements.yml и запустит плейбук  файла master.yml

4. Рекомендации и ошибки:

- в файле .gitlab-ci.yml в директиве `stages` не добавлен блок `build`, в строке 33 сместить `- master` вправо - не соблюдается структура документа
- в файле hosts вероятнее всего ошибка в указании домена в перменной domain_name
- в файле initial_user.yml в самом начале файла нет обязательного атрибута `---`, в модуле lineinfile лучше использовать двойные кавычки вместо одинарных

Общие рекомендации:
- модуль gather_facts: true необязательно использовать в значении true, это значение по умолчанию, лучше вынести его в ansible.cfg, если необходимо отключить везде и включать там где переменные будут использоваться
