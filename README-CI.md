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

### Pushing the Image to Dockerhub

Dockerhub reppsitory was reused from previous project. After building and testing the image locally, log into Dockerhub using a Personal Access Token.

```
docker login -u kan0sh1
docker push kan0sh1/akuma-fitness:latest
```

The docker push command uploads the image to DockerHub respository with the latest tag.

Dockerhub was checked to verify the image was uploaded successfully.

[Akuma Fitness DockerHub Repository](https://hub.docker.com/r/kan0sh1/akuma-fitness)

## 2. Github Actions and Dockerhub

### Github Repository Secrets

To allow GitHub Actions to upload Docker Images to DockerHub, two respository secrets were configured.

- DOCKER_USERNAME: stores my DockerHub username.

- DOCKER_TOKEN: stores my DockerHub Personal Access Token.

These are easily added by going to Github repository:

- Choose settings
- Secrets and Variables
- Actions 
- New Repsitory Secret

***It is important to never save a PAT or Password in a repository where anyone else could see this personal information.***

### GitHub Actions

For this portion of the project, a YAML was created from the official Docker Documentation to create my GitHub Actions workflow. Changes were made to the example document to match my existing DockerHub Repository.

The workflow uses on: push with the main branch specified. This means the workflow will only start when the changes are pushed to main. The pull_request trigger is unecessary for the project but was left in without branches specified in case it becomes necessary at a later time.

The contents: read permission allows the workflow to read the repository contents without giving extra permissions.

Docker/metadata-action@v6 action generates the tags and metadata used for the Docker image. The image name was changed from the example template to match the DockerHub repository. Since the username is saved in a secret file on GitHub I carried that styling over and kept the username secret by using a secret call defined from the documentation. The metadata action uses default tagging rules, generating branch based tags when the workflow runs.

Docker/login-action@v4 action signs into DockerHub using the DOCKER_USERNAME and DOCKER_TOKEN repositoru secrets. By using these secrets the workflow can aunthenticate without putting my credentials directly into the YAML file or having them saved in the public on Github. 

The docker/setup-buildx-action@v4 action sets up Docker Buildx, which is used by Docker to build the container image. 

The docker/build-push-action@v7 action builds the image using the Dockerfile in my repository and uploads it to DockerHub. 

The push: true setting tells the action to upload the image to DockerHub after it has been built. The tags, labels, and annotations will then be supplied by the metadata action also configured in the workflow.

### Part 2 Permalink: https://github.com/WSU-kduncan/ceg3120-cicd-ray163-f26/commit/683fcfe829641385764a90d274be5677599cd0bf

This is the commit containing the original GitHub Action workflow that was configured to build and push Docker images when changes were pushed to the main branch. This is the commit for the workflow prior to the semantic versioning update. 

## 3. Semantic Versioning

To start the semantic versioning, The GitHub action trigger was changed from pushes to main branch to pushes containing versioning tags. 

The branch filter was replaced with v*.*.* so the workflow would run when i pushed version tags. This allows Docker images to be published when a versioned release was made instead of every update to the website. 

### Creating Git Tags

After the workflow was updated to allow semantic versioning, the changes were commited and pushed to the main branch. 

An annotated Git tag was created named v1.0.0 using git tag -a command. This tag was used for the first full release of the website. The tag was pushed to GitHub using git push origin v1.0.0 which triggered the GitHub action workflow to build and publish the Docker Image. 

### Docker Image Version Tags

The Docker metadata action to generate image tags based on semantic version was updated. This update would allow the image to have the latest, major version, and major.minor version tags.

The semver patters from [Dockers Manage Tags and Actions](https://docs.docker.com/build/ci/github-actions/manage-tags-labels/) page was utilized. The {{major}} tag generates the major version, while allowing {{major}}.{{minor}} generates the major and minor versions together. 

The raw latest tag allows the newest release to be identified without specifying a version number. 

So pushing Git tag v1.2.5 would create Docker image tags 1, 1.2.5 and latest. 

### Docker Image Tags

After pushing the v1.0.0 Git tag, the git action workflow should trigger. Checking the DockerHub repository verified that the workflow successfully published the image with latest, 1, and 1.0 tags. 

## 4. Testing and Proof

![Docker Container](images/DockerTest.png)

Creating and running the Docker image. This was a test to show that the container was running as intended.

![GitHub Repository Secrets](images/RepoSecrets.png)

This screenshot shows the GitHub Secrets page with my username and token secret added in. The content of those fields is hidden in the screenshot.

![Main Branch Workflow](images/DockerTest.png)

Screenshot showing the YAML workflow successfully created a workflow in the github actions.

![Branch Workflow Test](images/BranchWorkflowTest.png)

To verify that the workflow only ran with main branch, I created a test branch. A small sentence was added to the bottom of the README, it was then commited and pushed to GitHub. I refreshed the page and verified that no new workflow was triggered by this push. This shows that the YAML restriction is built and working as intended.

![Website image test](images/WebsiteWorkflowUpdate.png)

To test if the workflow was publishing website updates, I made a small visible change to the index.html file and pushed the changes to the main branch. The push triggered another action run. After the workflow completed successfully, i pulled the updated docker image using the main tag. 

A new container was started using the updated image and i opened the website in my browser. The changes appeared correctly confirming the updated website files were pushed to Docker Successfully.

![Docker site with versioning](/images/DockerTag.png)

This screenshot shows that the updated versioning pushed to dockerhub successfully and generated all 3 expected tags.

![Untagged commit](/images/untaggedcommit.png)

This screenshot shows that after a successful commit the workflow action did not trigger due to the yaml file

## References

- [Dockerhub httpd](https://hub.docker.com/_/httpd) - Docker website with instructions on how to use Apache.

- [GitHub Docs: Respository Secrets](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets) - Shows how to add repository secrets into the GitHub Repository

- [DockerDocs Github Actions](https://docs.docker.com/build/ci/github-actions/) - Gives a YAML file showing how to set up the CI pipeline.

- [GitHub Workflow Syntax](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax) - Shows how workflows are structured giving a better understanding of what the parts of the YAML were doing and why.

- [Docker Metadata](https://github.com/docker/metadata-action) - Shows how metadata action generates tags. 

- [Docker Tags](https://docs.docker.com/build/ci/github-actions/manage-tags-labels/) - action workflow for versioning explanations. and updates to the yaml to create versioning pushes 

- [Git Tagging](https://git-scm.com/book/en/v2/Git-Basics-Tagging) - how to annotate a tag and push to the repository