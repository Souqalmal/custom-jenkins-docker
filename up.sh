#!/usr/bin/env bash

# Check number of arguments
if [ "$#" -lt 1 ]; then
    echo "USAGE: up.sh <port>"
  exit 2
fi

echo ">>>> Moving to $(dirname "$0")"
cd "$(dirname "$0")"
echo ">>>> Building docker image"
docker build -t sam/jenkins:latest .

echo ">>>> Removing old container"
docker rm -f jenkins || true

echo ">>>> Running new container"
docker run --name jenkins -d -p $1:8080 -p 50000:50000 \
    -v ~/jenkins_home:/var/jenkins_home \
    -v ~/.ssh:/var/jenkins_home/.ssh sam/jenkins:latest

echo ">>>> Tailing logs"
docker logs -f jenkins
