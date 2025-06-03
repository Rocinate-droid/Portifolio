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
                ssh-keyscan -H 10.0.2.50 >> /var/lib/jenkins/.ssh/known_hosts
                ansible -m ping webservers
                echo "$VAULT_PASSWORD" > password.txt
                ansible-playbook playbook.yml --vault-password-file password.txt
                rm password.txt
            '''
                }
            }
        }
        stage ("Create docker file and update in docker hub") {
            steps {
                sh '''
                   sudo docker build -t nginx-image:v2 .
                   sudo docker tag nginx-image:v2 typicalguy/nginx-image:v2
                   sudo docker push typicalguy/nginx-image:v2
                   '''
            }
        }
        stage ("Start docker service for image") {
            steps {
                sh 'sudo docker service update --image typicalguy/nginx-image:v2 nginx-service'
            }
        }
    }
}
