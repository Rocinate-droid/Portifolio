#!/bin/bash

cat <<EOT>> new_docker_file
FROM ubuntu
RUN apt update
RUN apt install nginx -y
workdir /home/newfolder
EXPOSE 80
RUN #add command
EOT

