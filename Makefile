.DEFAULT_GOAL := help

COMPOSE := docker compose
SERVICE := sftpgo

# Carga puertos desde .env si existe (para los mensajes de `make info`)
-include .env
SFTP_PORT     ?= 2022
WEBADMIN_PORT ?= 8080

.PHONY: help up down start stop restart pull update logs ps shell info user backup clean

help: ## Muestra esta ayuda
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

up: ## Levanta el servicio en segundo plano
	$(COMPOSE) up -d

down: ## Detiene y elimina el contenedor (los datos persisten)
	$(COMPOSE) down

start: ## Inicia el contenedor existente
	$(COMPOSE) start

stop: ## Detiene el contenedor sin eliminarlo
	$(COMPOSE) stop

restart: ## Reinicia el servicio
	$(COMPOSE) restart $(SERVICE)

pull: ## Descarga la última imagen de SFTPGo
	$(COMPOSE) pull

update: pull ## Actualiza la imagen y recrea el contenedor
	$(COMPOSE) up -d

logs: ## Sigue los logs del servicio
	$(COMPOSE) logs -f --tail=100 $(SERVICE)

ps: ## Muestra el estado del servicio
	$(COMPOSE) ps

shell: ## Abre una shell dentro del contenedor
	$(COMPOSE) exec $(SERVICE) sh

info: ## Muestra URLs y comandos de conexión
	@echo "SFTP:      sftp -P $(SFTP_PORT) <usuario>@localhost"
	@echo "Panel web: http://localhost:$(WEBADMIN_PORT)"

user: ## Crea carpeta de storage para un usuario: make user NAME=demo3
	@test -n "$(NAME)" || { echo "Uso: make user NAME=<username>"; exit 1; }
	mkdir -p storage/$(NAME)
	@echo "Carpeta storage/$(NAME) creada. Recuerda añadir el usuario en users.json."

backup: ## Crea un archivo .tar.gz de data/ y storage/ en backups/
	@mkdir -p backups
	tar -czf backups/sftpgo-$$(date +%Y%m%d-%H%M%S).tar.gz data storage
	@echo "Backup creado en backups/"

clean: ## Elimina el contenedor y los volúmenes anónimos
	$(COMPOSE) down -v --remove-orphans
