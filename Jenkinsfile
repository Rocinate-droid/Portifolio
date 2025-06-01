pipeline {
    agent any
    environment {
        VAULT_PASSWORD    = 'vault_password'
    }
    stages {
        stage ("Git SCM pull") {
            steps {
                git branch: 'resume_build', changelog: false, poll: false, url: 'https://github.com/Rocinate-droid/Portifolio.git'
                sh 'whoami'
            }
        }
         stage ("execute terraform build") {
            steps {
                sh '''
                   terraform init
                   terraform apply --auto-approve
                   '''
              }
            }
        stage ("execute ansible playbook") {
            steps {
              withCredentials([string(credentialsId: 'vault_password', variable: 'VAULT_PASSWORD')]) {
            sh '''
                ansible -m ping webservers
                echo "$VAULT_PASSWORD" > password.txt
                ansible-playbook playbook.yml --vault-password-file password.txt
                rm password.txt
            '''
                }
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
