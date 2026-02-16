package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		hostname, _ := os.Hostname()
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		fmt.Fprintf(w, `
			<!DOCTYPE html>
			<html>
			<head>
				<title>Segurança Máxima</title>
				<style>
					body { 
						margin: 0; height: 100vh; display: flex; 
						justify-content: center; align-items: center; 
						background: #0f172a; color: #22c55e; font-family: sans-serif;
					}
					.box { 
						text-align: center; padding: 40px; 
						border: 2px solid #22c55e; border-radius: 20px;
						box-shadow: 0 0 20px rgba(34, 197, 94, 0.2);
					}
					h1 { font-size: 3rem; margin: 0; }
					p { color: #94a3b8; margin-top: 10px; font-family: monospace; }
				</style>
			</head>
			<body>
				<div class="box">
					<h1>Zero vulnerabilidades</h1>
					<p>Hostname: %s</p>
				</div>
			</body>
			</html>
		`, hostname)
	})

	log.Printf("Servidor iniciado na porta %s", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
