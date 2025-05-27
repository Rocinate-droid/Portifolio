pipeline {
    agent any
    stages {
        stage ("Git SCM pull") {
            steps {
                git branch: 'resume_build', changelog: false, poll: false, url: 'https://github.com/Rocinate-droid/Portifolio.git'
                sh 'whoami'
            }
        }
        stage ("execute ansible playbook") {
            steps {
                  sh 'ansible-playbook playbook.yml'
            }
        }
        stage ("Create docker file") {
            steps {
                sh 'docker build --t nginx-image .'
            }
        }
        stage ("Start docker service") {
            steps {
                sh 'docker service create --name nginx-service --replicas=5 -p 80:80 nginx-image'
            }
        }
    }
}
