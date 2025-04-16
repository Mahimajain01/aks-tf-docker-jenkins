pipeline {
    agent any

    environment {
        ACR_NAME = 'acr-aks-tf98872'
        AZURE_CREDENTIALS_ID = 'jenkins-pipeline-sp'
        ACR_LOGIN_SERVER = "${ACR_NAME}.azurecr.io"
        IMAGE_NAME = 'webapiacrtfjenkinsdocker'
        IMAGE_TAG = 'latest'
        RESOURCE_GROUP = 'rg-aks-tf'
        AKS_CLUSTER = 'AKSClustermj'
        TF_WORKING_DIR = 'terraform'
        // TF_WORKING_DIR = '.'
        TERRAFORM_PATH = 'E:\\something\\Capgemini\\Cap-Training\\terraform.exe'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Mahimajain01/aks-tf-jenkins.git'
            }
        }

        // stage('Build .NET App') {
        //     steps {
        //         bat """
        //         echo "Checking .NET SDK version"
        //         dotnet --version
        //         dotnet publish webApi-ask-tf/webApi-ask-tf.csproj -c Release --framework net8.0
        //         """
        //     }
        // }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t %ACR_LOGIN_SERVER%/%IMAGE_NAME%:%IMAGE_TAG% -f webApi-ask-tf/Dockerfile webApi-ask-tf"
            }
        }

        stage('Terraform Init') {
            steps {
                bat """
                cd %TF_WORKING_DIR%
                "%TERRAFORM_PATH%" init
                """
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    bat """
                    cd %TF_WORKING_DIR%
                    "%TERRAFORM_PATH%" plan -out=tfplan
                    """
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([azureServicePrincipal(
                    credentialsId: AZURE_CREDENTIALS_ID,
                    subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID',
                    clientIdVariable: 'AZURE_CLIENT_ID',
                    clientSecretVariable: 'AZURE_CLIENT_SECRET',
                    tenantIdVariable: 'AZURE_TENANT_ID'
                )]) {
                    bat """
                    cd %TF_WORKING_DIR%
                    "%TERRAFORM_PATH%" apply -auto-approve tfplan
                    """
                }
            }
        }

        stage('Login to ACR') {
            steps {
                bat "az acr login --name %ACR_NAME%"
            }
        }

        stage('Push Docker Image to ACR') {
            steps {
                bat "docker push %ACR_LOGIN_SERVER%/%IMAGE_NAME%:%IMAGE_TAG%"
            }
        }

        stage('Get AKS Credentials') {
            steps {
                bat "az aks get-credentials --resource-group %RESOURCE_GROUP% --name %AKS_CLUSTER% --overwrite-existing"
            }
        }

        stage('Deploy to AKS') {
            steps {
                bat "kubectl apply -f deployment.yaml"
            }
        }
    }

    post {
        success {
            echo 'All stages completed successfully!'
        }
        failure {
            echo 'Build failed.'
        }
    }
}
