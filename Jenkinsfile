
pipeline {
    agent any

    stages {
        stage('Check Windows') {
            steps {
                bat 'whoami'
                bat 'git --version'
            }
        }

        stage('Check Docker') {
            steps {
                bat 'docker --version'
                bat 'docker compose version'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t talentflow-ai:latest .'
            }
        }

        stage('Run Docker Container') {
            steps {
                bat 'docker rm -f talentflow-ai-container 2>nul || exit /b 0'
                bat 'docker run -d --name talentflow-ai-container -p 8081:80 talentflow-ai:latest'
            }
        }

        stage('Verify Website') {
            steps {
                bat 'curl.exe -f http://localhost:8081/'
            }
        }
    }
}
