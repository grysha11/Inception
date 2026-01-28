COMPOSE_PATH = ./srcs
COMPOSE_FLAGS = --project-directory $(COMPOSE_PATH) --progress auto
DATA_PATH = /home/hzakharc/data

build:
	mkdir -p $(DATA_PATH)/db
	mkdir -p $(DATA_PATH)/wp
	docker compose $(COMPOSE_FLAGS) build --no-cache

run:
	docker compose $(COMPOSE_FLAGS) up -d

clean:
	docker compose $(COMPOSE_FLAGS) down -v

fclean: clean
		docker system prune -af
	

re:	fclean build run

.PHONY: build run clear fclean re