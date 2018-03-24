#!/usr/bin/env bash

echo ">>>> Moving to $(dirname "$0")"
cd "$(dirname "$0")"
echo ">>>> Building docker image"
docker build -t sam/jenkins:latest .

echo ">>>> Removing old container"
docker rm -f jenkins || true

echo ">>>> Running new container"
docker run --name jenkins -d -p 8080:8080 -p 50000:50000 \
    -v ~/jenkins_home:/var/jenkins_home sam/jenkins:latest \
    -v ~/.ssh:/var/jenkins_home/.ssh

echo ">>>> Tailing logs"
docker logs -f jenkins