package main

import (
	"log"
	"math/rand"
	"sync"
	"sync/atomic"
	"time"
)

func do(seconds int, action ...any) {
	log.Println(action...)
	randomMillis := 500*seconds + rand.Intn(500*seconds)
	time.Sleep(time.Duration(randomMillis) * time.Millisecond)
}

// Order struct to represent an order in the restaurant
type Order struct {
	id         uint64
	customer   string
	reply      chan *Order
	preparedBy string
}

// Global variables
var (
	waiter       = make(chan *Order, 3) // Waiter can hold up to 3 orders
	orderCounter atomic.Uint64          // Atomic counter for unique order IDs
)

// Cook function simulates a cook preparing meals
func cook(name string) {
	log.Println(name, "starting work")
	for {
		order := <-waiter // Blocking call to get an order
		do(10, name, "cooking order", order.id, "for", order.customer)
		order.preparedBy = name
		order.reply <- order // Send the completed order back to the customer
	}
}

// Customer function simulates a customer placing orders and eating meals
func customer(name string, wg *sync.WaitGroup) {
	defer wg.Done() // Notify waitGroup when done
	mealsEaten := 0

	for mealsEaten < 5 {
		order := &Order{
			id:       orderCounter.Add(1), // Increment atomic counter for unique ID
			customer: name,
			reply:    make(chan *Order),
		}

		log.Println(name, "placed order", order.id)

		select {
		case waiter <- order: // Try to place the order with the waiter
			meal := <-order.reply // Wait for the cooked meal
			do(2, name, "eating cooked order", meal.id, "prepared by", meal.preparedBy)
			mealsEaten++
		case <-time.After(7 * time.Second): // Timeout after 7 seconds
			do(5, name, "waiting too long, abandoning order", order.id)
		}
	}
	log.Println(name, "is going home")
}

func main() {

	// Seed the random number generator
	rand.Seed(time.Now().UnixNano())

	// List of customers
	customers := []string{"Ani", "Bai", "Cat", "Dao", "Eve", "Fay", "Gus", "Hua", "Iza", "Jai"}

	// WaitGroup to wait for all customers to finish
	var wg sync.WaitGroup

	// Start cooks
	go cook("Remy")
	go cook("Colette")
	go cook("Linguini")

	// Start customers
	for _, customerName := range customers {
		wg.Add(1)
		go customer(customerName, &wg)
	}

	// Wait for all customers to finish
	wg.Wait()

	log.Println("Restaurant closing")
}
