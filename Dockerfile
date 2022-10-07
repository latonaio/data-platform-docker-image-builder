FROM cruizba/ubuntu-dind:latest

ENV TZ Asia/Tokyo

ARG AWS_ACCESS_KEY
ARG AWS_SECRET_KEY

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    make \
    jq \
    zip

WORKDIR /tmp

RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
RUN unzip awscliv2.zip
RUN aws/install -i /usr/local/aws-cli -b /usr/local/bin

ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY
ENV AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY
