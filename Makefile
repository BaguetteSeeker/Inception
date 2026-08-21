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

# Build and start
up: setup
	${COMPOSE} $(FILE) up

# Stops container
stop:
	docker stop ${FILE}

# Calls down target
clean: down
	${COMPOSE} ${FILE} down --volumes --rmi all

# Full clean of unused ressources
fclean: clean
	docker system prune -af
	sudo rm -rf $(DATA_DIR)

# Rebuild everything
re: fclean all

status:
	${COMPOSE} ${FILE} ps
logs:
	${COMPOSE} ${FILE} logs -f

.PHONY: all build up down clean fclean re status log

