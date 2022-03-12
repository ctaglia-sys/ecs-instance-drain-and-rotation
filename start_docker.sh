#!/bin/bash
# Detect the arch
# the fxxc docker in linux dosen't support --platform ,so this is a trick to avoid the error
DETECTED_ARCH=$(uname -a | grep -i arm64 && echo "linux/arm64" || echo "linux/amd64")

current_md5=$(md5sum Dockerfile | cut -d " " -f1)

if [ ! -f dockerfile_checksum ] || [ "$(cat dockerfile_checksum)" != "$current_md5" ]
then
  echo $current_md5 > dockerfile_checksum
  docker build \
      --build-arg TARGETPLATFORM="linux/amd64" \
      --build-arg USER=$(whoami) \
      --build-arg USER_ID=$(id -u) \
      --build-arg GROUP=$(id -g) \
      -t ecs-rotate-instances:latest \
      -f Dockerfile .
fi

echo "##################"
echo "Levanta contenedor"
echo "##################"
# docker run --network host -it --rm --name zinio-tools \
docker run --network host -it --rm \
    -v ~/.aws:$HOME/.temp_aws:ro \
    -v $(pwd)/:/app \
    -w /app \
    -e AWS_SDK_LOAD_CONFIG=1 \
    -e AWS_DEFAULT_REGION="us-west-2" \
    -e AWS_PROFILE=console \
    ecs-rotate-instances:latest

