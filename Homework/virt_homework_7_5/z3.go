package main
 
import (
	"fmt"
	"math"
)
 
func main() {
 
	var length float64
	fmt.Print("Введите количество метров:  ")
	fmt.Scanf("%f", &length)
 	
	foot := length * 3.281
	fmt.Println(length, " метров равны ", math.Round(foot*100)/100, " футов")
 
}
