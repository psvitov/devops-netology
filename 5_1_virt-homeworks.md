
<h2><b>Домашнее задание к занятию "5.1. Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения."</b></h2>

<h4><b>Задача 1. Опишите кратко, как вы поняли: в чем основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС.</b></h4>

Аппаратная виртуализация - в основе нее лежит полноценное ПО, устанавливающееся на аппаратную часть,и имеющее единое целое, так называемый программно-аппаратный комплекс, используемый весь функционал. Яркий пример VMVare. Так же аппаратная виртуализация лежит в основе работы процессоров Intel и AMD, без которой не будет работать виртуализация на основе ОС.<p><p>
Паравиртуализация - система, позволяющая работать как глобальная надстройка над основной ОС, но при этом использующаяся только для этого функционала. Есть четкая связка "Операционная система - Гипервизор". Через гипервизор идет управление всеми гостевыми системами.<p><p>
Виртуализация на основе ОС - основное отличие от паравитруализации - использует то же ядро, что и в основной системе, то есть при использовании ядра основной системы, нельзя запустить систему на другом ядре. Часто такую виртуализацию называют контейнерной виртуализацией.<p><p>

<h4><b>Задача 2. Выберите один из вариантов использования организации физических серверов, в зависимости от условий использования.

Организация серверов: физические сервера, паравиртуализация, виртуализация уровня ОС.<p>
Условия использования:Высоконагруженная база данных, чувствительная к отказу. Различные web-приложения. Windows системы для использования бухгалтерским отделом. Системы, выполняющие высокопроизводительные расчеты на GPU.<p>
  
Опишите, почему вы выбрали к каждому целевому использованию такую организацию.</b></h4>

Высоконагруженная база данных -> либо физический сервер, либо аппаратная виртуализация <p>
Пояснение: высоконагруженные БД очень критичны к объемам памяти и количеству ядер процессоров, так как в них выполняется множественные запросы и операции. Я бы все таки выбрал аппаратную виртуализацию в кластере, так как при этом есть возможность более оптимально использовать ресурсы в нужное время (увеличить объем памяти или количество ядер), тогда как физический сервер не так просто нарастить или уменьшить в любой момент времени.<p><p>

Различные web-приложения -> виртуализация на основе ОС или паравиртуализация<p>
Пояснение: веб-приложения не имеют критичных данных, обычно эти данные хранятся в БД, тут не так важна скорость обработки информации, скорее скорость вывода информации и функции запрос-ответ. Виртуализация на основе ОС - поможет на первоначальных этапах, когда веб-прилоежние не обрабатывает большое количество пользователей, в дальнейшем лучше перейти на паравиртуализацию<p><p>
Windows системы для использования бухгалтерским отделом -> Паравиртуализация <p>
Пояснение: для использования windows систем наиболее сейчас подходит удаленный рабочий стол (терминальная сессия), где используются клиент-серверные системы, и бухгалтерам нужен только доступ к удаленному рабочему столу. Для этого оптимально будет подходить паравиртуализация.<p><p>
Системы, выполняющие высокопроизводительные расчеты на GPU. -> физический сервер<p>
Пояснение: для высокопроизводительных расчетов на GPU необходим мощный графический процессор. Такой процессор не обеспечит виртуальная машина, так как в основной своей массе серверная часть не обладает такой вычислительной мощностью на основе GPU <p><p>

<h4><b>Задача 3. Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.<p>

Сценарии:<p>

100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.<p>
Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.<p>
Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры.<p>
Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.</b></h4><p><p>
100 виртуальных машин на базе Linux и Windows -> Аппаратная виртуализация на VMWare, Hyper-V<p>
Пояснение: Паравиртуализация не справится в полной мере с балансировщиком нагрузки, репликацией данных и автоматизированным механизмом создания резервных копий. Опять же - 100 виртуальных машин, особенно Windows based инфраструктуры - это большая нагрузка на аппаратную часть, значит и балансировка должна быть оптимально настроена.<p><p>
Hаиболее производительное бесплатное open source решение -> Паравиртуализация на основе Proxmox VE, KVM.<p>
Пояснение: Оптимальное соотношение производительности и управления гостевыми ОС. Proxmox позволяет использовать кластеризацию, что позволяет повысить отказоустойчивость, поддерживаются любые гостевые ОС, как Linux, так и Windows.<p><p>
Решение для виртуализации Windows инфраструктуры -> Паравиртуализация на Hyper-V. <p>
Пояснение: наиболее максимальная совместимость данных продуктов, так как производитель ПО - один. <p><p>
Рабочее окружение для тестирования -> Виртуализация уровня ОС на LXC.<p>
Пояснение: Так как необходимы госетвые ОС для тестирования, нет необходимости разворачивать полноценную виртуализацию, так как скорее всего, после тестирования данные гостевые ОС уже не понадобятся<p><p>
  
<h4><b>Задача 4. Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, то создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.</b></h4><p><p>
  
При использовании гетерогенной среды виртуализации могут возникать следующие проблемы: <p>
 - несовместимость гипервизоров разных систем виртуализации;<p>
 - несовместимость гостевых ОС, особенно с разными ядрами;<p>
 - неудобство управления госетвыми ОС; <p>
 - проблемы с миграцией между системами виртуализации; <p>
 - проблемы с балансировкой нагрузки. <p>
 Минимизация рисков - использование гостевых ОС с одинаковым ядром, желательно одного разработчика, резервирование на разные источники от разных виртуальных платформ.<p>
При своем выборе я бы не создавал гетерогенну среду. По своему опыту сталкивался, когда основной гипервизор имел гостевую ОС, в которой была установлена виртуализация на уровне ОС с несколькими гостевыми ОС, и при проблеме на основной гостевой ОС - отключались все гостевые машины внутри нее.
                                                                                        
  
  