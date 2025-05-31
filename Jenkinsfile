pipeline {
    agent any
    environment {
       VAULT_PASSWORD = credentials("vault_password")
       AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')         // Use Jenkins credentials
       AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
    }
    stages {
        stage ("Git SCM pull") {
            steps {
                git branch: 'resume_build', changelog: false, poll: false, url: 'https://github.com/Rocinate-droid/Portifolio.git'
                sh 'env | grep aws'
            }
        }
         stage ("execute terraform build") {
          
            withCredentials([
                    usernamePassword(
                        credentialsId: 'aws_creds',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ])
            steps {
                sh '''
                   terraform init
                   terraform apply --auto-approve
                   '''
            }
        }
        stage ("execute ansible playbook") {
            steps {
                  sh '''
                     echo "$VAULT_PASSWORD" > password.txt
                     ansible-playbook playbook.yml --vault-password-file password.txt
                     rm password.txt
                     '''
            }
        }
        stage ("Create docker file") {
            steps {
                sh 'sudo docker build -t nginx-image .'
            }
        }
        stage ("Start docker service for image") {
            steps {
                sh 'sudo docker service create --name nginx-service --replicas=3 -p 80:80 nginx-image'
            }
        }
    }
}
