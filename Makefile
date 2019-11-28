cnf ?= config.env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

dpl ?= deploy.env
include $(dpl)
export $(shell sed 's/=.*//' $(dpl))

all: build run

build:
	docker build -t $(APP_NAME) .

run:
	docker run -it -d -p $(PORT):$(PORT) $(APP_NAME)

#up: build run ## Run container on port configured in `config.env` (Alias to run)

#stop: ## Stop and remove a running container
#	docker stop $(APP_NAME); docker rm $(APP_NAME)
