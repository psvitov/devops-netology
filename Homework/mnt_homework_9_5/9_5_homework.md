# Домашнее задание к занятию "09.05 Teamcity"

## Подготовка к выполнению

1. В Ya.Cloud создайте новый инстанс (4CPU4RAM) на основе образа `jetbrains/teamcity-server`
2. Дождитесь запуска teamcity, выполните первоначальную настройку
3. Создайте ещё один инстанс(2CPU4RAM) на основе образа `jetbrains/teamcity-agent`. Пропишите к нему переменную окружения `SERVER_URL: "http://<teamcity_url>:8111"`
4. Авторизуйте агент
5. Сделайте fork [репозитория](https://github.com/aragastmatb/example-teamcity)
6. Создать VM (2CPU4RAM) и запустить [playbook](./infrastructure)

---
### Ответ:
---

1. Создаем 2 виртуальные машины:

![9_5_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_5/9_5_1.PNG)

2. Проверяем доступность и настройку `Teamcity`:

![9_5_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_5/9_5_2.PNG)

![9_5_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_5/9_5_3.PNG)

3. Создаем еще одну ВМ для `Nexus` и проверяем работу:

![9_5_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_5/9_5_4.PNG)

![9_5_5.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_5/9_5_5.PNG)


## Основная часть

1. Создайте новый проект в teamcity на основе fork
2. Сделайте autodetect конфигурации
3. Сохраните необходимые шаги, запустите первую сборку master'a
4. Поменяйте условия сборки: если сборка по ветке `master`, то должен происходит `mvn clean deploy`, иначе `mvn clean test`
5. Для deploy будет необходимо загрузить [settings.xml](./teamcity/settings.xml) в набор конфигураций maven у teamcity, предварительно записав туда креды для подключения к nexus
6. В pom.xml необходимо поменять ссылки на репозиторий и nexus
7. Запустите сборку по master, убедитесь что всё прошло успешно, артефакт появился в nexus
8. Мигрируйте `build configuration` в репозиторий
9. Создайте отдельную ветку `feature/add_reply` в репозитории
10. Напишите новый метод для класса Welcomer: метод должен возвращать произвольную реплику, содержащую слово `hunter`
11. Дополните тест для нового метода на поиск слова `hunter` в новой реплике
12. Сделайте push всех изменений в новую ветку в репозиторий
13. Убедитесь что сборка самостоятельно запустилась, тесты прошли успешно
14. Внесите изменения из произвольной ветки `feature/add_reply` в `master` через `Merge`
15. Убедитесь, что нет собранного артефакта в сборке по ветке `master`
16. Настройте конфигурацию так, чтобы она собирала `.jar` в артефакты сборки
17. Проведите повторную сборку мастера, убедитесь, что сбора прошла успешно и артефакты собраны
18. Проверьте, что конфигурация в репозитории содержит все настройки конфигурации из teamcity
19. В ответ предоставьте ссылку на репозиторий

---
### Ответ:
---

1. Создаем новый проект на основе `fork` и проводим `autodetect` конфигурации:

![9_5_6.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_5/9_5_6.PNG)

2. Меняем условия сборки, редактируем базовый шаг и добавляем шаг `Deploy` предварительно добавив файл settings.xml:

![9_5_7.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_5/9_5_7.PNG)

![9_5_8.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_5/9_5_8.PNG)

3. В pom.xml меняем ссылку на репозиторий nexus

![9_5_9.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_5/9_5_9.PNG)

4. Запускаем сборку и проверяем `Nexus`:

![9_5_10.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_5/9_5_10.png)

![9_5_11.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_5/9_5_11.png)


P.S: Первый `build` запустился с ошибкой, так как неправильно указал IP в `pom.xml`. После исправления `build` автоматически стартовал и выполнился успешно, последующие запуски были проверочные, запускались с ошибкой "400 Repository does not allow updating assets: maven-releases" потому что версия 0.0.2 в репозитории уже существует.


5. Создаем новую ветку в репозитории - `feature/add_reply`:

6. Добавляем новый метод тестирования:

- Welcomer.java

>
    public String sayHunter(){
            return "You are good hunter";
        }   

- WelcomerTest.java

>
    @Test
        public void welcomerSaysHunter() {
            assertThat(welcomer.sayHunter(), containsString("hunter"));
        }

После внесения изменений `build` отработал автоматически:

![9_5_12.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_5/9_5_12.png)

7. С помощью `merge` cливаем произвольную ветку `feature/add_reply` в `master`

8. Настраиваем конфигурацию на сбор артефактов `jar`, проверяем работу:

![9_5_13.png](https://github.com/psvitov/devops-netology/blob/main/Homework/mnt_homework_9_5/9_5_13.png)


9. Ссылка на репозиторий [mnt_homework_9_5](https://github.com/psvitov/example-teamcity)


