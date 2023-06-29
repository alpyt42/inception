# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: alric <alric@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/06/06 18:44:33 by alric             #+#    #+#              #
#    Updated: 2023/06/29 17:08:20 by alric            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

all: up

up:
	@docker-compose -f ./srcs/docker-compose.yml up --detach

down:
	@docker-compose -f ./srcs/docker-compose.yml down

build:
	@docker-compose -f srcs/docker-compose.yml up --detach --build

logs:
	@docker-compose -f srcs/docker-compose.yml logs

clean:
	@docker stop nginx wordpress mariadb 2>/dev/null || true
	@docker rm nginx wordpress mariadb 2>/dev/null || true
	@docker volume rm db wp 2>/dev/null || true
	@docker rmi srcs_nginx srcs_wordpress srcs_mariadb 2>/dev/null || true
	@docker network rm inception_net 2>/dev/null || true

re: clean all

.PHONY: all up down build clean logs re
