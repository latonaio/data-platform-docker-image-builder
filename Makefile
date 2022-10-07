DOCKER_USERNAME := $(shell jq -r .docker.username env.json)
DOCKER_PASSWORD := $(shell jq -r .docker.password env.json)

# make generate-docker-compose targetPath=../repository-name
generate-docker-compose:
	echo $(targetPath)
	bash generateDockerComposeYaml.sh $(targetPath)

docker-hub-login:
	echo $(DOCKER_USERNAME)
	docker login \
		--username $(DOCKER_USERNAME) \
		--password $(DOCKER_PASSWORD)

# build and push data-platform-docker-image-builder image to aws
builder-docker-push:
	bash docker-build.sh push

# pc から実行する場合
# make build-deploy-resource repositoryName=repository-name
build-deploy-resource:
	docker-compose exec data-platform-docker-image-builder \
		bash /app/builder/buildDeployResource.sh /app/mnt/ $(repositoryName)
