#!make

GEN_DOCKER_ENTRYPOINT_SH = ./gen-entrypoint-sh.sh
TARGET_ENTRYPOINT_SH = ./config/mongo-entrypoint/docker-entrypoint-initdb.sh
DOCKER_COMPOSE_FILE = ./docker-compose.yml
ENV_FILE = ./.env

.PHONY: all gen_entrypoint_sh up restart stop down
all: gen_entrypoint_sh up

gen_entrypoint_sh: $(GEN_DOCKER_ENTRYPOINT_SH)
	sh $(GEN_DOCKER_ENTRYPOINT_SH)

up: $(TARGET_ENTRYPOINT_SH) $(DOCKER_COMPOSE_FILE) $(ENV_FILE)
	docker-compose -f $(DOCKER_COMPOSE_FILE) up -d

restart: $(TARGET_ENTRYPOINT_SH)
	docker-compose -f $(DOCKER_COMPOSE_FILE) restar

stop: $(TARGET_ENTRYPOINT_SH)
	docker-compose -f $(TARGET_ENTRYPOINT_SH) stop

down: $(TARGET_ENTRYPOINT_SH)
	docker-compose -f $(DOCKER_COMPOSE_FILE) down