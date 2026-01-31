# Makefile for common development tasks

.PHONY: help dev run build css css-watch ts ts-watch db-up db-down db-reset migrate test clean assets

# Default target
help:
	@echo "Available commands:"
	@echo "  make dev        - Run server with hot reload (requires air)"
	@echo "  make run        - Run server directly"
	@echo "  make build      - Build the application"
	@echo "  make assets     - Build both CSS and TypeScript"
	@echo "  make css        - Build Tailwind CSS"
	@echo "  make css-watch  - Watch and rebuild Tailwind CSS"
	@echo "  make ts         - Build TypeScript"
	@echo "  make ts-watch   - Watch and rebuild TypeScript"
	@echo "  make db-up      - Start PostgreSQL with docker-compose"
	@echo "  make db-down    - Stop PostgreSQL"
	@echo "  make db-reset   - Reset database (delete all data)"
	@echo "  make migrate    - Run database migrations"
	@echo "  make test       - Run tests"
	@echo "  make clean      - Clean build artifacts"

# Development
dev:
	@if command -v air > /dev/null; then \
		air; \
	else \
		echo "air not installed. Run: go install github.com/cosmtrek/air@latest"; \
		go run ./cmd/web; \
	fi

run:
	go run ./cmd/web

build:
	go build -o bin/server ./cmd/web

# Assets (CSS + TypeScript)
assets:
	npm run css:build
	npm run ts:build

# CSS
css:
	npm run css:build

css-watch:
	npm run css:watch

# TypeScript
ts:
	npm run ts:build

ts-watch:
	npm run ts:watch

# Database
db-up:
	docker-compose up -d db

db-down:
	docker-compose down

db-reset:
	docker-compose down -v
	docker-compose up -d db
	@echo "Waiting for database to be ready..."
	@sleep 3
	@make migrate

migrate:
	rm -f web/static/js/*.js
	rm -f web/static/js/*.js.map
	@if [ -z "$(DATABASE_URL)" ]; then \
		psql postgres://user:password@localhost:5432/yourdb?sslmode=disable -f migrations/0001_init.sql; \
	else \
		psql $(DATABASE_URL) -f migrations/0001_init.sql; \
	fi

# Testing
test:
	go test -v ./...

# Clean
clean:
	rm -rf bin/
	rm -rf tmp/
	rm -f web/static/css/site.css
