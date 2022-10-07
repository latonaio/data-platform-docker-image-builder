#!/bin/bash

REPOSITORY_PATH=$1
REPOSITORY_NAME=$2

cd /app/builder

AWS_ACCESS_KEY=$(jq -r .aws.accessKey env.json)
AWS_SECRET_KEY=$(jq -r .aws.secretKey env.json)
AWS_ACCOUNT_ID=$(jq -r .aws.accountId env.json)
AWS_ECR_PUBLIC_REGION=$(jq -r .aws.ecr.public.region env.json)
AWS_ECR_PUBLIC_ARN=$(jq -r .aws.ecr.public.arn env.json)
AWS_ECR_PUBLIC_ALIAS=$(jq -r .aws.ecr.public.alias env.json)

echo "Repository Path: $REPOSITORY_PATH"
echo "Repository Name: $REPOSITORY_NAME"
cd $REPOSITORY_PATH && bash docker-build.sh

DOCKER_PUSH_ARN="$AWS_ECR_PUBLIC_ARN/$AWS_ECR_PUBLIC_ALIAS"

echo $DOCKER_PUSH_ARN

aws ecr-public get-login-password \
    --region ${AWS_ECR_PUBLIC_REGION} \
    | docker login --username AWS --password-stdin $DOCKER_PUSH_ARN

docker tag $REPOSITORY_NAME:latest \
    $DOCKER_PUSH_ARN/$REPOSITORY_NAME:latest

docker push $DOCKER_PUSH_ARN/$REPOSITORY_NAME:latest
