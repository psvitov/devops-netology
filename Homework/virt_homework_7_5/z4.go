package main
 
import (
	"fmt"
)
 
func main() {
 
	x := []int{4,8,9,6,86,6,8,57,8,2,63,7,0,37,3,4,8,3,2,7,19,97,9,17,27}
	min := 0

        for i, value := range x {
            if (i == 0) {
               min = value 
            } else {
               if (value < min){
                    min = value
                    }
                  }
        }
            fmt.Println("В массиве ",x , "минимальное число : ", min)
 
}
