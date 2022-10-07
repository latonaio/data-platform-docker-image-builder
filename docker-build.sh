#!/bin/sh

PUSH=$1
DATE="$(date "+%Y%m%d%H%M")"

AWS_ACCESS_KEY=$(jq -r .aws.accessKey env.json)
AWS_SECRET_KEY=$(jq -r .aws.secretKey env.json)
AWS_ACCOUNT_ID=$(jq -r .aws.accountId env.json)
AWS_ECR_PRIVATE_REGION=$(jq -r .aws.ecr.private.region env.json)
AWS_ECR_PRIVATE_PROFIlE=$(jq -r .aws.ecr.private.profile env.json)

DOCKER_PUSH_TAG_FOR_ECR=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_ECR_PRIVATE_REGION}.amazonaws.com/data-platform-docker-image-builder

if [[ AWS_ECR_PRIVATE_REGION == "" ]]; then
  echo "No aws region specified"
  exit 1
fi

if [[ $AWS_ECR_PRIVATE_PROFIlE == "" ]]; then
  echo "No aws profile specified"
  exit 1
fi

docker build -t data-platform-docker-image-builder:latest . \
      --build-arg AWS_ACCESS_KEY=${AWS_ACCESS_KEY} \
      --build-arg AWS_SECRET_KEY=${AWS_SECRET_KEY}

if [[ $PUSH == "push" ]]; then
    # aws ecr login
    aws ecr get-login-password \
          --region ${AWS_ECR_PRIVATE_REGION} \
          --profile ${AWS_ECR_PRIVATE_PROFIlE} \
          | docker login --username AWS --password-stdin ${DOCKER_PUSH_TAG_FOR_ECR}

    docker tag data-platform-docker-image-builder:latest \
          ${DOCKER_PUSH_TAG_FOR_ECR}:${DATE}

    docker tag data-platform-docker-image-builder:latest \
          ${DOCKER_PUSH_TAG_FOR_ECR}:latest

    docker push ${DOCKER_PUSH_TAG_FOR_ECR}:${DATE}
    docker push ${DOCKER_PUSH_TAG_FOR_ECR}:latest
fi
