COMPOSE_FILE = srcs/docker-compose.yml
DATA_PATH = /home/mkerkeni/data
MARIADB_DATA = $(DATA_PATH)/mariadb
WORDPRESS_DATA = $(DATA_PATH)/wordpress

all: up

up: setup
	docker-compose -f  $(COMPOSE_FILE) up -d

down: 
	docker-compose -f $(COMPOSE_FILE) down

start:
	docker-compose -f $(COMPOSE_FILE) start

stop:
	docker-compose -f $(COMPOSE_FILE) stop

logs:
	docker-compose -f $(COMPOSE_FILE) logs

setup:
	sudo mkdir -p $(MARIADB_DATA) $(WORDPRESS_DATA)

clean:
	sudo rm -rf $(DATA_PATH)

fclean: clean
	docker system prune -f -a --volumes
	docker volume rm srcs_mariadb_data srcs_wordpress_data


.PHONY: all up down start stop logs clean fclean
