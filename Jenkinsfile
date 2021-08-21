pipeline {
    agent any
    stages {
        stage('Terraform initialize') {
            steps {
               sh 'cd terraform/robo2 ; terraform initialize'
            }
        }
        stage('Terraform apply config') {
            steps {
               terraform apply -auto-approve
            }
        }
    }
 }