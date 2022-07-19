# Домашнее задание к занятию "7.5. Основы golang" 

## Задача 1. Установите golang.
1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

---
### Ответ:
---

1. Скачиваем последнюю версию `golang`:

> 
    root@DevOps:~# wget https://go.dev/dl/go1.18.4.linux-amd64.tar.gz

2. Распаковываем архив`go1.18.4.linux-amd64.tar.gz`:

> 
    root@DevOps:~# tar -zxvf go1.18.4.linux-amd64.tar.gz -C /usr/local/

3. Настраиваем переменную среду для включения каталога `bin`:

> 
    root@DevOps:~# export PATH=$PATH:/usr/local/go/bin

4. Проверяем установку `golang`:

>
    root@DevOps:~# go version
    go version go1.18.4 linux/amd64
    root@DevOps:~#

![7_5_1.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_7_5/7_5_1.png)


## Задача 2. Знакомство с gotour.
У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/). 
Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, 
осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.

---
### Ответ:
---

#### Ознакомился

## Задача 3. Написание кода. 
Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода 
на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные 
у пользователя, а можно статически задать в коде.
    Для взаимодействия с пользователем можно использовать функцию `Scanf`:
    ```
    package main
    
    import "fmt"
    
    func main() {
        fmt.Print("Enter a number: ")
        var input float64
        fmt.Scanf("%f", &input)
    
        output := input * 2
    
        fmt.Println(output)    
    }
    ```
 
2. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
    ```
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    ```
3. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.

В виде решения ссылку на код или сам код. 

---
### Ответ:
---

1. Код решения задачи:

[z3.go](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_7_5/z3.go)

Результат выполнения:

![7_5_2.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_7_5/7_5_2.png)

2. Код решения задачи:

[z4.go](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_7_5/z4.go)

Результат выполнения:

![7_5_3.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_7_5/7_5_3.png)

3. Код решения задачи (модернизированный):

[z5.go](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_7_5/z5.go)

Результат выполнения (модернизированный):

![7_5_4.png](https://github.com/psvitov/devops-netology/blob/main/Homework/virt_homework_7_5/7_5_4.png)

---
