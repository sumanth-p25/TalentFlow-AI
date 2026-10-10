
pipeline {
    agent any

    options {
        timestamps()
    }

    environment {
        IMAGE_NAME = 'talentflow-ai'
        TEST_CONTAINER = 'talentflow-ai-ci-test'
        APP_CONTAINER = 'talentflow-ai-ci'
        TEST_PORT = '18080'
        APP_PORT = '8082'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
                echo 'Source code checked out successfully.'
            }
        }

        stage('Validate Files') {
            steps {
                bat '''
                    if not exist Dockerfile exit /b 1
                    if not exist index.html exit /b 1
                    if not exist style.css exit /b 1
                    if not exist script.js exit /b 1
                '''
                echo 'Required application files are present.'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %IMAGE_NAME%:%BUILD_NUMBER% .'
            }
        }

        stage('Test Docker Container') {
            steps {
                bat 'docker rm -f %TEST_CONTAINER% 2>NUL'
                bat 'docker run -d --name %TEST_CONTAINER% -p %TEST_PORT%:80 %IMAGE_NAME%:%BUILD_NUMBER%'

                bat '''
                    powershell -NoProfile -Command "$ProgressPreference='SilentlyContinue'; $ok=$false; for ($i=0; $i -lt 12; $i++) { try { $r=Invoke-WebRequest -UseBasicParsing http://localhost:18080 -TimeoutSec 3; if ($r.StatusCode -eq 200) { $ok=$true; break } } catch {}; Start-Sleep -Seconds 2 }; if (-not $ok) { docker logs talentflow-ai-ci-test; exit 1 }"
                '''
            }
        }

        stage('Deploy Application') {
            steps {
                bat 'docker rm -f %APP_CONTAINER% 2>NUL'
                bat 'docker run -d --restart unless-stopped --name %APP_CONTAINER% -p %APP_PORT%:80 %IMAGE_NAME%:%BUILD_NUMBER%'
                bat '''
                    powershell -NoProfile -Command "$ProgressPreference='SilentlyContinue'; Start-Sleep -Seconds 3; try { $r=Invoke-WebRequest -UseBasicParsing http://localhost:8082 -TimeoutSec 10; if ($r.StatusCode -ne 200) { exit 1 } } catch { Write-Error $_; exit 1 }"
                '''
            }
        }
    }

    post {
        always {
            bat 'docker rm -f %TEST_CONTAINER% 2>NUL'
        }
        success {
            echo 'CI/CD SUCCESS: Build, test, and deployment completed.'
            echo 'TalentFlow AI: http://localhost:8082'
        }
        failure {
            echo 'CI/CD FAILED. Check the stage logs above.'
        }
    }
}
