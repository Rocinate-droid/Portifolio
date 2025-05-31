pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage("Git SCM pull") {
            steps {
                git branch: 'resume_build', changelog: false, poll: false, url: 'https://github.com/Rocinate-droid/Portifolio.git'
                sh 'env | grep AWS'
            }
        }

        stage("execute terraform build") {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws_creds',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    sh '''
                        terraform init
                        terraform apply --auto-approve
                    '''
                }
            }
        }

        stage("execute ansible playbook") {
            steps {
                withCredentials([
                    string(credentialsId: 'vault_password', variable: 'VAULT_PASSWORD')
                ]) {
                    sh '''
                        echo "$VAULT_PASSWORD" > password.txt
                        ansible-playbook playbook.yml --vault-password-file password.txt
                        rm password.txt
                    '''
                }
            }
        }

        stage("Create docker image") {
            steps {
                sh 'docker build -t nginx-image .'
            }
        }

        stage("Start docker service for image") {
            steps {
                sh 'docker service create --name nginx-service --replicas=3 -p 80:80 nginx-image'
            }
        }
    }
}

