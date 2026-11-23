
#!/bin/bash
set -e

docker stop akuma-fitness
docker rm akuma-fitness

docker pull kan0sh1/akuma-fitness:latest

docker run -d --name akuma-fitness --restart always -p 80:80 kan0sh1/akuma-fitness:latest
