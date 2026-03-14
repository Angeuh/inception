NAME = inception

COMPOSE = docker compose -f srcs/docker-compose.yml

# Host data folders
MARIADB_DATA = srcs/requirements/mariadb/data
WORDPRESS_DATA = srcs/requirements/wordpress/data

all:
	mkdir -p $(MARIADB_DATA) $(WORDPRESS_DATA)
	sudo chown -R 1001:1001 $(MARIADB_DATA)
	sudo chown -R 1001:1001 $(WORDPRESS_DATA)
	sudo chmod -R u+rwX $(MARIADB_DATA) $(WORDPRESS_DATA)
	docker compose -f srcs/docker-compose.yml up -d --build

down:
	$(COMPOSE) down

start:
	$(COMPOSE) start

stop:
	$(COMPOSE) stop

restart: down up

logs:
	$(COMPOSE) logs -f

clean: 
	$(COMPOSE) down -v --rmi all

fclean: clean
	sudo rm -rf $(MARIADB_DATA) $(WORDPRESS_DATA)
	sudo mkdir -p $(MARIADB_DATA) $(WORDPRESS_DATA)
	sudo chown -R $$USER:$$USER $(MARIADB_DATA) $(WORDPRESS_DATA)
	sudo chmod -R u+rwX $(MARIADB_DATA) $(WORDPRESS_DATA)
	docker system prune -af

re: fclean all

.PHONY: all up down start stop restart logs clean fclean re prepare