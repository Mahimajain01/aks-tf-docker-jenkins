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
                        bat 'docker run --rm -v %cd%:/workspace -w /workspace hashicorp/terraform:1.6.6 init'
                        bat 'docker run --rm -v %cd%:/workspace -w /workspace hashicorp/terraform:1.6.6 apply -auto-approve'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def dockerImage = docker.build("${ACR_NAME}.azurecr.io/${IMAGE_NAME}")
                }
            }
        }

        stage('Push Docker Image to ACR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'acr-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    bat """
                        docker login ${ACR_NAME}.azurecr.io -u %USERNAME% -p %PASSWORD%
                        docker push ${ACR_NAME}.azurecr.io/${IMAGE_NAME}
                    """
                }
            }
        }

        stage('Deploy to AKS') {
            steps {
                script {
                    bat "az aks get-credentials --resource-group ${RESOURCE_GROUP} --name myAKSCluster"
                    bat "kubectl apply -f deployment.yaml"
                }
            }
        }
    }
}
