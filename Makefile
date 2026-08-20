NAME = inception
COMPOSE= docker compose -f
FILE = srcs/docker-compose.yml
DATA_DIR = /home/epinaud/data


all: up

setup:
    @mkdir -p /home/epinaud/data
    @mkdir -p $(DATA_DIR)/mariadb
    @mkdir -p $(DATA_DIR)/wordpress

# Build images
build: setup
    ${COMPOSE} $(FILE) build

# Start services
up: build
     ${COMPOSE} $(FILE) up -d

# Stops + deletes the container as well as its associated  image, volume and network
down:
	${COMPOSE} ${FILE} down

# Stops container
stop:
	${COMPOSE} ${FILE} stop

# Clean containers and images
clean:
	${COMPOSE} ${FILE} down

# Full clean of unused ressources (Stopped containers, Unused images (by active containers), Unmounted volumes, Unused networks)
fclean: clean
    docker system prune -af
    sudo rm -rf $(DATA_DIR)

# Rebuild everything
re: fclean all

status:
	${COMPOSE} ${FILE} ps
logs:
	${COMPOSE} ${FILE} logs -f

.PHONY: all build up down clean fclean re
