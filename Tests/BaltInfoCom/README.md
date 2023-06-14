### Тестовое задание:

Написать ansible скрипт реализующий следующее:

1. на ОС ubuntu LTS установить openldap сервер
2. установить в ldap пароль администратора
3. установить в ldap domain и organization
4. добавить 2 пользователя в ldap
6. добавить 2 группы в ldap

### Решение:

Создадим простой манифест Ansible с указанием хоста, но в случае распространения на несколько серверов, лучше использовать отдельный файл hosts и доработать манифест, разделив зал\дачи на роли:

```
---
- name: Install OpenLDAP Server
  hosts: ldap
  become: true
  tasks:

# Замена доменного имени на подходящее в файле hosts , изменения после установки можно откатить
    - name: Change file HOSTS
      ansible.builtin.lineinfile:
        path: /etc/hosts
        search_string: '127.0.0.1'
        line: 127.0.0.1 <MY-HOSTNAME>.<MY-DOMAIN>.<COM> <MY-HOSTNAME>
        owner: root
        group: root
        mode: '0644'

# Установка пакетов OpenLDAP
    - name: Install OpenLDAP
      ansible.builtin.apt:
        pkg:
        - slapd
        - ldap-utils

# Установка пароля администратора
    - name: Admin Passwd
      ansible.builtin.lineinfile:
        path: /etc/openldap/slapd.conf
        search_string: 'rootpw'
        line: rootpw 123456

# Создание файла конфигурации LDIF
    - name: Create LDIF-file
      ansible.builtin.file:
        path: /home/domain.ldif
        state: touch
        mode: 0644

# Заполнение файла конфигурации с указанием домена и организации
    - name: Update LDIF file
      ansible.builtin.blockinfile:
        path: /home/domain.ldif
        block: |
          dn: dc=<MY-DOMAIN>,dc=<COM>
          objectclass: dcObject
          objectclass: organization
          o: <MY-ORGANIZATION>
          dc: <MY-DOMAIN>
          dn: cn=admin,dc=<MY-DOMAIN>,dc=<COM>
          objectclass: organizationalRole
          cn: admin

# Изменение конфигурации LDAP-сервера
    - name: Update LDIF file
      ansible.builtin.command: ldapadd -x -D "cn=admin,dc=<MY-DOMAIN>,dc=<COM>" -W -f /home/domain.ldif

# Создание файла конфигурации LDIF для OU групп и пользователей
    - name: Create LDIF-file
      ansible.builtin.file:
        path: /home/ou.ldif
        state: touch
        mode: 0644

# Заполнение файла конфигурации для создания OU групп и пользователей
    - name: Update LDIF file
      ansible.builtin.blockinfile:
        path: /home/ou.ldif
        block: |
          dn: dc=<MY-DOMAIN>,dc=<COM>
          dc: <MY-DOMAIN>
          objectClass: top
          objectClass: domain

          dn: ou=users,dc=<MY-DOMAIN>,dc=<COM>
          ou: Users
          objectClass: top
          objectClass: organizationalUnit
          description: Central location for UNIX users

          dn: ou=groups,dc=<MY-DOMAIN>,dc=<COM>
          ou: Groups
          objectClass: top
          objectClass: organizationalUnit
          description: Central location for UNIX groups

# Изменение конфигурации LDAP-сервера
    - name: Update LDAP server
      ansible.builtin.command: ldapmodify -a -xZZWD cn=admin,dc=<MY-DOMAIN>,dc=<COM> -W -f /home/ou.ldif

# Создание файла конфигурации LDIF для создания 2-х групп
    - name: Create LDIF-file
      ansible.builtin.file:
        path: /home/groups.ldif
        state: touch
        mode: 0644

# Заполнение файла конфигурации для создания создания 2-х групп
    - name: Update LDIF file
      ansible.builtin.blockinfile:
        path: /home/groups.ldif
        block: |
          dn: cn=admins,ou=groups,dc=<MY-DOMAIN>,dc=<COM>
          cn: admins
          objectClass: top
          objectClass: posixGroup
          gidNumber: 1100
          description: UNIX systems administrators

          dn: cn=users,ou=groups,dc=<MY-DOMAIN>,dc=<COM>
          cn: users
          objectClass: top
          objectClass: posixGroup
          gidNumber: 1101
          description: UNIX users

# Изменение конфигурации LDAP-сервера
    - name: Update LDAP server
      ansible.builtin.command: ldapmodify -a -xZZWD cn=admin,dc=<MY-DOMAIN>,dc=<COM> -W -f /home/groups.ldif

# Создание файла конфигурации LDIF для создания 2-х пользователей
    - name: Create LDIF-file
      ansible.builtin.file:
        path: /home/users.ldif
        state: touch
        mode: 0644

# Заполнение файла конфигурации для создания создания 2-х пользователей
    - name: Update LDIF file
      ansible.builtin.blockinfile:
        path: /home/users.ldif
        block: |
          dn: cn=superadmin,ou=users,dc=<MY-DOMAIN>,dc=<COM>
          uid: superadmin
          gecos: Super Administrator
          objectClass: top
          objectClass: account
          objectClass: posixAccount
          objectClass: shadowAccount
          userPassword: {SSHA}RsAMqOI3647qg1gAZF3x2BKBnp0sEVfa
          shadowLastChange: 15140
          shadowMin: 0
          shadowMax: 99999
          shadowWarning: 7
          loginShell: /bin/bash
          uidNumber: 1100
          gidNumber: 1100
          homeDirectory: /home/superadmin

          dn: cn=superuser,ou=users,dc=<MY-DOMAIN>,dc=<COM>
          uid: superuser
          gecos: Super User
          objectClass: top
          objectClass: account
          objectClass: posixAccount
          objectClass: shadowAccount
          userPassword: {SSHA}RsAMqOI3647qg1gAZF3x2BKBnp0sEVfa
          shadowLastChange: 15140
          shadowMin: 0
          shadowMax: 99999
          shadowWarning: 7
          loginShell: /bin/bash
          uidNumber: 1101
          gidNumber: 1101
          homeDirectory: /home/superuser

# Изменение конфигурации LDAP-сервера
    - name: Update LDAP server
      ansible.builtin.command: ldapmodify -a -xZZWD cn=admin,dc=<MY-DOMAIN>,dc=<COM> -W -f /home/users.ldif
```

В самом манифесте необходимо заменить переменные `<MY-HOSTNAME>, <MY-DOMAIN>, <COM>`, либо вынести их в отдельный файл переменных `variables`

