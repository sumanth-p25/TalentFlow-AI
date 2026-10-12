
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

        stage('Trivy Security Scan') {
            steps {
                bat 'docker run --rm -v "%WORKSPACE%:/work" -v trivy-cache:/root/.cache -w /work aquasec/trivy:0.75.0 fs --scanners vuln,misconfig,secret --severity HIGH,CRITICAL --exit-code 1 --no-progress .'
            }
        }

        stage('Run Docker Container') {
            steps {
                bat 'docker rm -f talentflow-ai-container 2>nul || exit /b 0'
                bat 'docker run -d --name talentflow-ai-container -p 8082:8080 talentflow-ai:latest'
            }
        }

        stage('Verify Website') {
            steps {
                bat 'curl.exe -f -I http://localhost:8082/'
            }
        }
    }
}
