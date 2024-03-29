# Домашнее задание к занятию "11.02 Микросервисы: принципы"

Вы работаете в крупной компанию, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps специалисту необходимо выдвинуть предложение по организации инфраструктуры, для разработки и эксплуатации.

## Задача 1: API Gateway 

Предложите решение для обеспечения реализации API Gateway. 
Составьте сравнительную таблицу возможностей различных программных решений. На основе таблицы сделайте выбор решения.

Решение должно соответствовать следующим требованиям:
- Маршрутизация запросов к нужному сервису на основе конфигурации
- Возможность проверки аутентификационной информации в запросах
- Обеспечение терминации HTTPS

---
### Ответ:
---

Рассмотрим основные распространенные шаблоны развертывания `API Gateway`:

- Пограничный шлюз - наиболее распространенный шаблон шлюза API, который соответствует традиционной архитектуре контроллера доставки приложений (ADC).
- Двухуровневый шлюз - двухуровневый/многоуровневый шаблон шлюза, который вводит разделение ролей для нескольких шлюзов.
- Микрошлюз - основывается на двухуровневом подходе, предоставляя отдельным командам выделенный шлюз.
- Шлюз для каждого модуля - шаблон шлюза для каждого модуля, изменяет шаблон микрошлюза, встраивая прокси-шлюзы в отдельные модули или контейнеры.
- Сервисный шлюз - шаблон развертывает шлюз в качестве входящего и исходящего прокси-сервера вместе с микрослужбой.

| Критерии  | Пограничный шлюз   | Двухуровневый шлюз   | Микрошлюз   | Шлюз для каждого модуля   | Сервисный шлюз   |
| :-------: | :-------: | :-------: | :-------: | :-------: | :-------: |
| SSL/TLS-терминация   | +    | +    | +    | +    | +    |
| Аутентификация   | +    | +    | +    | ...    | +    |
| Логгирование   | ...    | +    | ...    | +    | +    |
| Отслеживание инъекции   | ...    | +    | ...    | ...    | +    |
| Балансировка нагрузки   | ...    | +    | +    | ...    | +    |
| Интеграция обнаружения сервисов   | ...    | +    | +    | ...    | +    |
| Маршрутизация   | +    | ...    | +    | ...    | ...    |
| Авторизация   | +    | +    | ...    | ...    | +    |
| Ограничение скорости и очередь   | +    | ...    | +    | +    | ...    |
| Манипулирование запросом/ответом   | +    | ...    | ...    | ...    | ...    |

Проанализировав таблицу и вводные данные можно сделать вывод, что для организации инфраструктуры для разработки и эксплуатации наиболее подходят **Пограничный шлюз** и **Микрошлюз**.

## Задача 2: Брокер сообщений

Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.

Решение должно соответствовать следующим требованиям:
- Поддержка кластеризации для обеспечения надежности
- Хранение сообщений на диске в процессе доставки
- Высокая скорость работы
- Поддержка различных форматов сообщений
- Разделение прав доступа к различным потокам сообщений
- Простота эксплуатации

---
### Ответ:
---


| Критерии  | RabbitMQ  | ActiveMQ  | Qpid C++  | SwiftMQ  | Artemis  | Apollo  | Kafka  |
| :------- | :-------: | :-------: | :-------: | :-------: | :-------: | :-------: | :-------: |
| Подписка на сообщения  | +  | +  | +  | +  | +  | +  | +  |
| Передача данных  | Одно направленная, широко вещательная, групповая  | Одно направленная, широко вещательная  | Одно направленная, широко вещательная  | Одно направленная  | Одно направленная, широко вещательная  | Одно направленная, широко вещательная  | Одно направленная, широко вещательная, групповая  |
| Упорядоченная доставка сообщений  | +  | +  | +  | -  | +  | -  | +  |
| Гарантированная доставка сообщений  | +  | +  | +  | +  | +  | +  | +  |
| Кластеризация  | +  | +  | +  | +  | +  | -  | +  |
| Восстановление каналов после потери связи  | +  | +  | +  | +  | +  | -  | +  |
| Масштабируемость  | +  | +  | +  | +  | +  | +  | +  |
| Контроль доступа  | +  | +  | +  | +  | +  | +  | +  |
| SSL/TLS  | +  | +  | +  | +  | +  | +  | +  |
| Открытый код  | +  | +  | +  | -  | +  | +  | +  |

Проанализировав таблицу и вводные данные можно сделать вывод, что оптимальным брокером сообщений можно выбрать одно из 2-х решенийа: **RabbitMQ** и **Apache Kafka**.


