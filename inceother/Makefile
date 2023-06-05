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
	@docker stop $$(docker ps -qa);\
	docker rm $$(docker ps -qa);\
	docker rmi -f $$(docker images -qa);\
	docker volume rm $$(docker volume ls -q);\
	docker network rm $$(docker network ls --format '{{if ne .Name "bridge"}}{{if ne .Name "host"}}{{if ne .Name "none"}}{{.Name}}{{end}}{{end}}{{end}}')

.PHONY: all up down build clean logs