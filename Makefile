COMPOSE_PATH = ./srcs
COMPOSE_FLAGS = --project-directory $(COMPOSE_PATH) --progress auto

build:
	docker compose $(COMPOSE_FLAGS) build --no-cache

run: 
	docker compose $(COMPOSE_FLAGS) up -d

clean:
	docker compose $(COMPOSE_FLAGS) down -v

fclean:
	docker compose $(COMPOSE_FLAGS) up -d --build

re:	fclean build run

.PHONY: build run clear fclean re