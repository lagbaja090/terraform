#!/bin/bash
sudo hostname docker
sudo apt update -y 
sudo apt install docker.io -y
sudo systemctl start docker
sudo usermod -aG docker ubuntu 
sudo su - ubuntu
docker run -p 8080:80 nginx