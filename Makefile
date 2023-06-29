# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: alric <alric@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/06/06 18:44:33 by alric             #+#    #+#              #
#    Updated: 2023/06/29 19:42:16 by alric            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

all: up

up: clean
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

re: clean all

.PHONY: all up down build clean logs re
