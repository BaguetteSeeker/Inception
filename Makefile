NAME = inception
COMPOSE = docker compose -f
FILE = srcs/docker-compose.yml
DATA_DIR = /home/epinaud/data


all: up

setup:
	mkdir -p /home/epinaud/data
	mkdir -p ${DATA_DIR}/mariadb
	mkdir -p ${DATA_DIR}/wordpress

# Start containers
start:
	${COMPOSE} ${FILE} start

# Builds and run / Background execution
build:
	${COMPOSE} ${FILE} up -d

# Stops container
stop:
	${COMPOSE} ${FILE} down

# Calls down target
clean: down
	${COMPOSE} ${FILE} down --volumes --rmi all

# Full clean of unused ressources
fclean: clean
	docker system prune -af
	sudo rm -rf $(DATA_DIR)

# Rebuild everything
re: fclean all

# Shows online containers (add -a for offline ones)
status:
	${COMPOSE} ${FILE} ps

# Reads in real time logs from running containers (avoids running services in the foreground and blocking prompt)
logs:
	${COMPOSE} ${FILE} logs -f

.PHONY: all build up down clean fclean re status log

