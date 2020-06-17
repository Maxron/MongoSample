#!make

GEN_DOCKER_ENTRYPOINT_SH = ./gen-entrypoint-sh.sh
TARGET_ENTRYPOINT_SH = ./config/mongo-entrypoint/docker-entrypoint-initdb.sh
DOCKER_COMPOSE_FILE = ./docker-compose.yml
DOCKER_COMPOSE_REPL_FILE = ./docker-compose-replicaset.yml

# Basic env 
ENV_FILE = ./.env
include $(ENV_FILE)

# Replica Set node env
NODE_ENV = ./config/nodes
include $(NODE_ENV)

.PHONY: all gen_entrypoint_sh up restart stop down 
all: gen_entrypoint_sh up

gen_entrypoint_sh: $(GEN_DOCKER_ENTRYPOINT_SH)
	sh $(GEN_DOCKER_ENTRYPOINT_SH)

up: gen_entrypoint_sh $(DOCKER_COMPOSE_FILE) $(ENV_FILE)
	docker-compose -f $(DOCKER_COMPOSE_FILE) up -d

restart: $(TARGET_ENTRYPOINT_SH)
	docker-compose -f $(DOCKER_COMPOSE_FILE) restar

stop: $(TARGET_ENTRYPOINT_SH)
	docker-compose -f $(TARGET_ENTRYPOINT_SH) stop

down: $(TARGET_ENTRYPOINT_SH)
	docker-compose -f $(DOCKER_COMPOSE_FILE) down


.PHONY: genkey
genkey:
ifeq (,$(wildcard $(MONGO_KEYFILE_NAME)))
	openssl rand -base64 756 > $(MONGO_KEYFILE_NAME)
	chmod 400 $(MONGO_KEYFILE_NAME)
else
	@echo "[[ Warnning ]] Key exist !!"
endif

.PHONY: rs
rs: gen_entrypoint_sh $(DOCKER_COMPOSE_REPL_FILE) $(ENV_FILE) $(MONGO_KEYFILE_NAME)
	docker-compose -f $(DOCKER_COMPOSE_REPL_FILE) up -d

.PHONY: rs-init
rs-init: 
	docker exec -ti $(CONTAINER_NAME) mongo admin --host localhost -u $(MONGO_INITDB_ROOT_USERNAME) -p $(MONGO_INITDB_ROOT_PASSWORD) --eval "rs.initiate();rs.conf()"

.PHONY: rs-add-dns
rs-add-dns:
	docker exec -ti $(CONTAINER_NAME) bash -c 'cat /resource/hosts >> /etc/hosts'
	
.PHONY: rs-down
rs-down: $(DOCKER_COMPOSE_REPL_FILE)
	docker-compose -f $(DOCKER_COMPOSE_REPL_FILE) down

.PHONY: rs-add-nodes
rs-add-nodes:
	docker exec -ti $(CONTAINER_NAME) mongo admin --host localhost -u $(MONGO_INITDB_ROOT_USERNAME) -p $(MONGO_INITDB_ROOT_PASSWORD) --eval $(RS_NODES)

.PHONY: rs-status
rs-status:
	docker exec -ti $(CONTAINER_NAME) mongo admin --host localhost -u $(MONGO_INITDB_ROOT_USERNAME) -p $(MONGO_INITDB_ROOT_PASSWORD) --eval "rs.status()"
