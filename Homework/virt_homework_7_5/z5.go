package main

import "fmt"

func main() {
	
	min := 0
	max := 0
	del := 0

	fmt.Print("Введите начальное число: ")
	fmt.Scan(&min)
	
	fmt.Print("Введите конечное число: ")
        fmt.Scan(&max)

	fmt.Print("Введите делитель: ")
        fmt.Scan(&del)


	for i := min; i <= max; i++ {
		if (i%del) == 0 {
                    fmt.Print(i,", ")
                    }
                }
        }
