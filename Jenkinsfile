pipeline {
    agent any
    stages {
        stage ("Git SCM pull") {
            steps {
               git branch: 'resume_build', changelog: false, poll: false, url: 'https://github.com/Rocinate-droid/Portifolio.git' //change github credentials here
                sh 'whoami'
            }
        }
         stage ("execute terraform build") {
            steps {
                // change the command to terraform destroy --auto-approve after the usage and run the pipeline again to clean up node-instance aws resources
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
                mkdir -p ~/.ssh
                ssh-keyscan -H 10.0.2.50 >> ~/.ssh/known_hosts
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
                //update docker image details here if needed
                sh ''' 
                   sudo docker build -t nginx-image:v2 . 
                   sudo docker tag nginx-image:v2 typicalguy/nginx-image:v2
                   sudo docker push typicalguy/nginx-image:v2
                   '''
            }
        }
        stage ("Start docker service for image and updated if needed") {
            steps {
                //update docker service details here if needed
                sh '''
                sudo docker service create --name nginx-service --replicas=5 -p 80:80 typicalguy/nginx-image:v2
                sudo docker service update --image typicalguy/nginx-image:v2 nginx-service
                   '''
            }
        }
    }
}
