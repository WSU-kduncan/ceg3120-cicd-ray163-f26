# CEG 3120 Project 6 - Continuous Integration

## Project Overview

### CI Workflow Diagram

## 1. Docker Website and Container

### Website Files

For this project Akuma Fitness website was reused from earlier project. The website was generated from ChatGPT, using prompt: 

- I need two simple html pages and a css file. Create these for me and make them themed around an anime inspired gym.

This created three files:

- [index.html](web-content/index.html)

- [about.html](web-content/about.html)

- [style.css](web-content/style.css)

### Dockerfile

The Dockerfile is created in the root of the repository to build the website container using Apache HTTP Server.

```
FROM http:2.4
COPY web-content/ /user/local/apache2/htdocs/
```

FROM instruction comes from the official Apache HTTP server image. COPY is used to move the website files into the default directory that Apache uses to serve web content. 

### Running the Docker Container

From the image I started a container to verify it was building and working correctly:

```
docker run -d --name akuma-ci-test -p 8080:80 kan0sh1/akuma-fitness:latest
```

The -d option runs the container in the background and -p 8080:80 maps 8080 from my computer to port 80 inside the container.

Docker ps was used to verify the container was running. I opened localhost:8080 to verify that the image built and was running the website correctly.

## 2. Github Actions and Dockerhub

## 3. Semantic Versioning

## 4. Testing and Proof

## References

- [Dockerhub httpd](https://hub.docker.com/_/httpd) - Docker website with instructions on how to use Apache.