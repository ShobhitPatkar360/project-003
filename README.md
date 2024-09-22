# Project-003 : Deploying a node js application to kubernetes cluster

## Overview

In this project, I am going to deploy a node js application on kubernetes cluster. I will be using AWS as cloud service provider. First I will show how we can do the deployment manually then I will show how we can automate the deployment by using CD/CI pipeline. It means when once commit would be made to code in github then change would be reflected to our deployment.

## Architecture

![This is our server-setup](https://github.com/ShobhitPatkar360/cold-learning/blob/94fae9b915de54b0628b743ffa87e9ab4283edef/pic/project-003.png)

### Technologies used

- Git
- AWS
- Jenkins
- Docker
- Kubernetes

## Presentation Video
[![](https://github.com/ShobhitPatkar360/cold-learning/blob/94fae9b915de54b0628b743ffa87e9ab4283edef/pic/project-003.png)](https://www.youtube.com/watch?v=u-YWtdbpEhQ&pp=ygUOd2hhdCBpcyBkb2NrZXI%3D)]



[Presentation of Project](https://www.youtube.com/watch?v=u-YWtdbpEhQ&pp=ygUOd2hhdCBpcyBkb2NrZXI%3D)

<iframe width="560" height="315" src="https://www.youtube.com/watch?v=u-YWtdbpEhQ&pp=ygUOd2hhdCBpcyBkb2NrZXI%3D" title="YouTube Video" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

# Some helpful instructions

## Installing software

preferred link - [https://github.com/ShobhitPatkar360/cold-learning/blob/main/devops/intallation-guidance.md](https://github.com/ShobhitPatkar360/cold-learning/blob/main/devops/intallation-guidance.md) 


## Working with Kubernetes

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

## Working with Dockerfile

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

## Working with Docker images and containers

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
## Manifest file to create node application deployment
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-application-deployment
  annotations: 
    kubernetes.io/change-cause: "This is again latest  version" 
spec:
  minReadySeconds: 10 
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  strategy:
    type: Recreate
  template:
    metadata:
      name: node-app-pod
      labels:
        app: myapp
    spec:
      containers:
      - name: node-app-container
        image: shubh360/nodejs-project-03:latest
```

## Manifest file to create our Nodeport Service
```bash
apiVersion: v1
kind: Service
metadata:
  name: my-nodeport-service
  labels:
    name: nodeport-label
spec:
  selector:
    app: myapp
  type: NodePort
  ports:
  - name: http
    port: 8000
    targetPort: 8000
    nodePort: 30033 
    protocol: TCP
```

## Our Pipeline code

```bash
pipeline {
    agent { label 'agent2'}

    stages {
        stage('Checkout Code') { // Descriptive stage name
            steps {
                checkout scmGit(
                    branches: [[name: 'main']],
                    extensions: [],
                    userRemoteConfigs: [[url: 'https://github.com/ShobhitPatkar360/project-003.git']]
                )
            }
        }

        stage('Clean Workspace') { // Consistent capitalization
            steps {
                cleanWs() // Existing function for cleaning workspace
            }
        }

        stage('Build Docker Image') { // Combined stages for clarity
            steps {                
                    echo 'Copying essential files to our workspace via git clone'
                    sh 'git clone https://github.com/ShobhitPatkar360/project-003.git'

                    echo 'Deleting image if any existing'
                    sh 'docker rmi shubh360/nodejs-project-03:latest || true'

                    echo 'Build image from docker file'
                    sh 'docker build -t shubh360/nodejs-project-03:latest'                
            }
        }
        
        stage('Pushing image to DockerHub') {
            steps {
                echo 'Pushing the image to DockerHub'
                withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh 'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
                    sh 'docker push shubh360/nodejs-project-03:latest'
                }
            }
        }
        stage('Deploying our Node.js Application') {
            steps {
                echo 'Deleting old deployment (if exists)'
                sh 'kubectl delete deployment node-application-deployment || true'
                
                echo 'Creating latest deployment'
```
## Problems

1. The repository already have the origin, there is a need to change the origin
`git remote set-url origin [git@gitlab.com](mailto:git@gitlab.com):KodeKloud/repository-1.git`
2. setting username was also the problem so id sat 
`git config --global [user.name](http://user.name/) "Your Name"
git config --global user.email "[your.email@example.com](mailto:your.email@example.com)"`

3. Error - Found multiple CRI endpoints on the host. Please define which one do you wish to use
4. There is no external ip for my deployed service in kubernetes ( just retry). I  have to manually copy the worker node’s public ip address
5. Login to docker hub using credentials
6. Github webhook setup - Actually I was unaware about the groovy syntax of adding webhook and installation of github integration plugin
