package main
 
import (
	"fmt"
)
 
func main() {
 
	var length float64
	fmt.Print("Введите количество метров:  ")
	fmt.Scanf("%f", &length)
 	
	foot := length * 3.281
	fmt.Println(length, " метров равны ", foot, " футов")
 
}
