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
                sh 'kubectl apply -f ./project-003/node-app-deploy.yml'
                
                echo 'Creating our Nodeport service'
                sh 'kubectl apply -f ./project-003/nodeport-service.yml'
            }
        }
        stage('See your Node IP and Node Port') {
            steps {
                echo 'Get deployments and services'
                sh 'kubectl get deploy -o wide && kubectl get svc -o wide'
                echo 'Now access your application'
            }
        }
    }
}

