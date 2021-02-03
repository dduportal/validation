package main

import (
	"fmt"
	"io"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

func main() {
	// Print a line in the logs
	httpAddr := "localhost:9999"
	fmt.Println("HTTP Server listening on", httpAddr)

	// Start an HTTP server using the custom router
	log.Fatal(http.ListenAndServe(httpAddr, setupRouter()))
}

func setupRouter() *mux.Router {
	// Create a new empty HTTP Router
	r := mux.NewRouter()

	// When an HTTP GET request is received on the path /health, delegates to the function "HealthCheckHandler()"
	r.HandleFunc("/health", HealthCheckHandler).Methods("GET")

	return r
}

func HealthCheckHandler(w http.ResponseWriter, r *http.Request) {
	// Print a line in the logs
	fmt.Println("HIT: healthcheck")

	// Write the string "ALIVE" into the response's body
	io.WriteString(w, "ALIVE")

	// End of the function: return HTTP 200 by default
}
