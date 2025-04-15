pipeline {
    agent any

    environment {
        ACR_NAME = 'acr-aks-tf98872'
        IMAGE_NAME = 'webapiacrtfjenkinsdocker'
        RESOURCE_GROUP = 'rg-aks-tf'
    }

    stages {
        stage('Terraform Init & Apply') {
            steps {
                dir('terraform') {
                    script {
                        docker.image('hashicorp/terraform:1.6.6').inside {
                            sh 'terraform init'
                            sh 'terraform apply -auto-approve'
                        }
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${ACR_NAME}.azurecr.io/${IMAGE_NAME}")
                }
            }
        }

        stage('Push Docker Image to ACR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'acr-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh 'docker login ${ACR_NAME}.azurecr.io -u $USERNAME -p $PASSWORD'
                    sh 'docker push ${ACR_NAME}.azurecr.io/${IMAGE_NAME}'
                }
            }
        }

        stage('Deploy to AKS') {
            steps {
                script {
                    sh 'az aks get-credentials --resource-group $RESOURCE_GROUP --name myAKSCluster'
                    sh 'kubectl apply -f deployment.yaml'
