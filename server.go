package main

import (
	"log"
	"net/http"
	"os"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/joho/godotenv"

	
	"github.com/paihari/go-pg-gqlgen/graph"
)

const defaultPort = "8080"

func main() {
	
	port := os.Getenv("PORT")
	if port == "" {
		port = defaultPort
	}

	err := godotenv.Load(); if err != nil {
		log.Fatal("Error loading .env file")
	}
	
	
	Database := graph.Connect()

	srv := handler.NewDefaultServer(
		graph.NewExecutableSchema(graph.Config{Resolvers: &graph.Resolver{DB: Database}}))

	   
	
	http.Handle("/", playground.Handler("GraphQL playground", "/query"))
	http.Handle("/query", srv)

	log.Printf("connect to http://localhost:%s/ for GraphQL playground", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
