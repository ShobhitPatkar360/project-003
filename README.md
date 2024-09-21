# Project-003 : Deploying a node js application to kubernetes cluster

## Overview

In this project, I am going to deploy a node js application on kubernetes cluster. I will be using AWS as cloud service provider. First I will show how we can do the deployment manually then I will show how we can automate the deployment by using CD/CI pipeline. It means when once commit would be made to code in github then change would be reflected to our deployment.

## Architecture

![This is our server-setup](https://github.com/ShobhitPatkar360/cold-learning/blob/6e0af1388d59a9c8668ce14137e0e36e3e4cb38c/pic/project-003.drawio.png)

### Links

youtube link - [https://www.youtube.com/watch?v=nplH3BzKHPk&list=PLlfy9GnSVerRqYJgVYO0UiExj5byjrW8u&index=15](https://www.youtube.com/watch?v=nplH3BzKHPk&list=PLlfy9GnSVerRqYJgVYO0UiExj5byjrW8u&index=15) 

website link - [https://www.trainwithshubham.com/blog/install-jenkins-on-aws](https://www.trainwithshubham.com/blog/install-jenkins-on-aws) 

document link - https://docs.google.com/document/d/1qos4eUfY4vZojjnZLSGw8D3A46Yy2r42uiZPyPxL17A/edit?pli=1#heading=h.i7ldfo5cwnft 

[https://docs.google.com/document/d/1qos4eUfY4vZojjnZLSGw8D3A46Yy2r42uiZPyPxL17A/edit?pli=1#heading=h.i7ldfo5cwnft](https://docs.google.com/document/d/1qos4eUfY4vZojjnZLSGw8D3A46Yy2r42uiZPyPxL17A/edit?pli=1#heading=h.i7ldfo5cwnft)

github link - [https://github.com/LondheShubham153/node-todo-cicd](https://github.com/LondheShubham153/node-todo-cicd) 

### Presentation

- Create a [readme.md](http://readme.md) file to show presentation. It should have photos and video
- Installation guide file
- files folder
- Basic knowledge file

### Technologies used

- Git
- AWS
- Jenkins
- Docker
- Kubernetes

## Problems

1. The repository already have the origin, there is a need to change the origin
`git remote set-url origin [git@gitlab.com](mailto:git@gitlab.com):KodeKloud/repository-1.git`
2. setting username was also the problem so id sat 
`git config --global [user.name](http://user.name/) "Your Name"
git config --global user.email "[your.email@example.com](mailto:your.email@example.com)"`

3. Error - Found multiple CRI endpoints on the host. Please define which one do you wish to use
4. There is no external ip for my deployed service in kubernetes ( just retry). I  have to manually copy the worker node’s public ip address
5. Login to docker hub using credentials
6. Github webhook setup - Actually I was unaware about the greevy syntax of adding webhook and installation of github integration plugin
7. 

# Instructions to do the tasks

## Kubernetes

```bash
# for deleting old deployment 
echo 'Delete old deployment (if exists)'
sh 'kubectl delete deployment my-deploy || true'

# for creating deployment and service
echo 'Create deployment and service'
sh 'kubectl apply -f my-deploy.yml'
sh 'kubectl apply -f node-port.yml'

# see your deployment and service
echo 'Get deployments and services'
sh 'kubectl get deploy && kubectl get svc'

# for accessing the application <node-ip>:<node-port>
```

## Docker Image creating

```bash
# Our base image
FROM node:12.2.0-alpine

# Setting our working directory
WORKDIR /node

# Copying all the code to our container
COPY . . 

# Installing the dependencies
RUN npm install
RUN npm run test
EXPOSE 8000

# Run the copied code
CMD ["node","app.js"]
```

## Docker image setup

```bash
# Removing docker container and image if any existing
echo 'Stop and remove any running container named my-web'
sh 'docker stop my-web || true && docker rm my-web || true && docker rmi my-web || true'

# Creating a docker image from docker file
echo 'Create Docker image from Dockerfile'
sh 'docker build . -t shubh360/my-web:latest'

# Pushing Docker image by providing credentials
withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable:'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
	sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
  sh 'docker push shubh360/my-web:latest'
```

## Installing software

preferred link - [https://github.com/ShobhitPatkar360/cold-learning/blob/main/devops/intallation-guidance.md](https://github.com/ShobhitPatkar360/cold-learning/blob/main/devops/intallation-guidance.md) 

rough work

```bash
docker credentials

docker login -u shubh360
dckr_pat_VlFE35lbwKBoUEN67PdmEsx9T1g

```
