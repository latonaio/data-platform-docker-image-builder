#!/bin/bash

export MOUNT_PATH=$1
export AWS_ACCESS_KEY=$(jq -r .aws.accessKey env.json)
export AWS_SECRET_KEY=$(jq -r .aws.secretKey env.json)

rm -rf docker-compose.yaml; envsubst <"docker-compose-template.yaml"> "docker-compose.yaml";
