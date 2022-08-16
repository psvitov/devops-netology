# Домашнее задание к занятию "09.03 CI\CD"

## Подготовка к выполнению

1. Создаём 2 VM в yandex cloud со следующими параметрами: 2CPU 4RAM Centos7(остальное по минимальным требованиям)
2. Прописываем в [inventory](./infrastructure/inventory/cicd/hosts.yml) [playbook'a](./infrastructure/site.yml) созданные хосты
3. Добавляем в [files](./infrastructure/files/) файл со своим публичным ключом (id_rsa.pub). Если ключ называется иначе - найдите таску в плейбуке, которая использует id_rsa.pub имя и исправьте на своё
4. Запускаем playbook, ожидаем успешного завершения
5. Проверяем готовность Sonarqube через [браузер](http://localhost:9000)
6. Заходим под admin\admin, меняем пароль на свой
7.  Проверяем готовность Nexus через [бразуер](http://localhost:8081)
8. Подключаемся под admin\admin123, меняем пароль, сохраняем анонимный доступ

---
### Ответ:
---

1. Создаем 2 ВМ: 

![9_3_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_3/9_3_1.png)

2. Прописываем IP-адреса в `hosts.yml`, добавляем ключ и запускаем `playbook`:

![9_3_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_3/9_3_2.png)

3. Проверяем готовность Sonarqube и Nexus:

![9_3_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_3/9_3_3.png)

![9_3_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_3/9_3_4.png)

## Знакомоство с SonarQube

### Основная часть

1. Создаём новый проект, название произвольное
2. Скачиваем пакет sonar-scanner, который нам предлагает скачать сам sonarqube
3. Делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)
4. Проверяем `sonar-scanner --version`
5. Запускаем анализатор против кода из директории [example](./example) с дополнительным ключом `-Dsonar.coverage.exclusions=fail.py`
6. Смотрим результат в интерфейсе
7. Исправляем ошибки, которые он выявил(включая warnings)
8. Запускаем анализатор повторно - проверяем, что QG пройдены успешно
9. Делаем скриншот успешного прохождения анализа, прикладываем к решению ДЗ

---
### Ответ:
---

1. Создаем новый проект:

![9_3_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_3/9_3_5.png)

2. Добавляем `bin` в переменную PATH и проверяем `sonar-scanner`:

![9_3_6.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_3/9_3_6.png)

3. Запускаем анализатор и смотрим результаты анализа:

![9_3_7.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_3/9_3_7.png)

![9_3_8.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_3/9_3_8.png)

4. Исправляем код, запускаем проверку снова и смотрим результаты:

![9_3_9.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_3/9_3_9.png)

![9_3_10.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_3/9_3_10.png)


## Знакомство с Nexus

### Основная часть

1. В репозиторий `maven-releases` загружаем артефакт с GAV параметрами:
   1. groupId: netology
   2. artifactId: java
   3. version: 8_282
   4. classifier: distrib
   5. type: tar.gz
2. В него же загружаем такой же артефакт, но с version: 8_102
3. Проверяем, что все файлы загрузились успешно
4. В ответе присылаем файл `maven-metadata.xml` для этого артефекта

---
### Ответ:
---

1. Загружаем в репозиторий первый артефакт:

![9_3_11.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_3/9_3_11.png)

2. Загружаем в репозиторий второй артефакт:

![9_3_12.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_3/9_3_12.png)

3. Проверяем загруженные файлы:

![9_3_13.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_3/9_3_13.png)

4. Ссылка на [maven-metadata.xml](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_3/maven-metadata.xml)

### Знакомство с Maven

### Подготовка к выполнению

1. Скачиваем дистрибутив с [maven](https://maven.apache.org/download.cgi)
2. Разархивируем, делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)
3. Удаляем из `apache-maven-<version>/conf/settings.xml` упоминание о правиле, отвергающем http соединение( раздел mirrors->id: my-repository-http-blocker)
4. Проверяем `mvn --version`
5. Забираем директорию [mvn](./mvn) с pom

---
### Ответ:
---

1. Устанавливаем `Maven` производим настройки и проверяем доступность:

![9_3_14.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_3/9_3_14.png)

### Основная часть

1. Меняем в `pom.xml` блок с зависимостями под наш артефакт из первого пункта задания для Nexus (java с версией 8_282)
2. Запускаем команду `mvn package` в директории с `pom.xml`, ожидаем успешного окончания
3. Проверяем директорию `~/.m2/repository/`, находим наш артефакт
4. В ответе присылаем исправленный файл `pom.xml`

---
### Ответ:
---

1. Меняем `pom.xml` под артефакт `java 8_282`:

![9_3_15.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_3/9_3_15.png)

2. Результат запуска команды `mvn package`:

![9_3_16.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_3/9_3_16.png)

3. Проверяем директорию `~/.m2/repository/`:

![9_3_17.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_3/9_3_17.png)

4. Ссылка на исправленный файл [pom.xml](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_3/pom.xml)
