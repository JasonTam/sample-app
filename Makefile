NAME = sample-app
PORT_CONTAINER = 5000
PORT_HOST = 5001
AWS_ACC_ID = $(shell aws sts get-caller-identity | jq .Account)
REGION = us-east-1
REGISTRY_URL = ${AWS_ACC_ID}.dkr.ecr.${REGION}.amazonaws.com
GIT_HASH = $(shell git rev-parse --short HEAD)

ifndef TAG  # if kwarg `TAG` not specified
	TAG = $(GIT_HASH)
endif

# Local Targets
build:
	docker build -t ${NAME} .

run-local:
	docker run -it \
		-p ${PORT_HOST}:${PORT_CONTAINER} \
		${NAME}

test:
	curl localhost:5001


# Remote Targets
ecs-login:
	$(shell aws ecr get-login --region ${REGION} --no-include-email)

create-repo: ecs-login
	aws ecr create-repository --repository-name $(NAME)

build-aws:
	docker build \
		-t $(REGISTRY_URL)/$(NAME):$(TAG) .

publish: ecs-login build-aws
	docker push $(REGISTRY_URL)/$(NAME):$(TAG)
