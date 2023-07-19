# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ale-cont <ale-cont@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/06/06 18:44:33 by alric             #+#    #+#              #
#    Updated: 2023/06/30 02:48:11 by ale-cont         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

all: up

up:
	@mkdir -p ${HOME}/data
	@mkdir -p ${HOME}/data/wordpress
	@mkdir -p ${HOME}/data/mariadb
	@docker compose -f ./srcs/docker-compose.yml up --detach

down:
	@docker compose -f ./srcs/docker-compose.yml down

build:
	@docker compose -f srcs/docker-compose.yml up --detach --build

logs:
	@docker compose -f srcs/docker-compose.yml logs

clean:
	@docker stop nginx wordpress mariadb 2>/dev/null || true
	@docker rm nginx wordpress mariadb 2>/dev/null || true
	@docker volume rm db wp 2>/dev/null || true
	@docker rmi srcs-nginx srcs-wordpress srcs-mariadb 2>/dev/null || true
	@docker network rm inception_net 2>/dev/null || true
	sudo rm -rf ${HOME}/data

re: clean all

.PHONY: all up down build clean logs re
