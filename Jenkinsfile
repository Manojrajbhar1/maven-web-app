pipeline {
    agent any

    environment {
        NEXUS_CREDS = credentials('nexus_creds')
        NEXUS_DOCKER_REPO = 'localhost:8082'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/Manojrajbhar1/maven-web-app.git'
            }
        }

        stage('Maven Build') {
            steps {
                script {
                    def mavenHome = tool name: 'maven 3.9.6', type: 'maven'
                    def mavenCMD = "${mavenHome}/bin/mvn"
                    sh "${mavenCMD} clean package"
                }
            }
        }

        stage('Publish to Nexus') {
            steps {
                script {
                    nexusArtifactUploader(
                        artifacts: [
                            [artifactId: 'maven-web-app', classifier: '', file: 'target/maven-web-app.war', type: 'war']
                        ],
                        credentialsId: 'nexus_creds',
                        groupId: 'sreegroup',
                        nexusUrl: '192.168.1.33:8081',
                        nexusVersion: 'nexus3',
                        protocol: 'http',
                        repository: 'sree-snapshot-Repo',
                        version: '1.0-SNAPSHOT'
                    )
                }
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building Docker Image'
                sh "docker build -t $NEXUS_DOCKER_REPO/maven-web-app:${BUILD_NUMBER} ."
            }
        }

        stage('Docker Login') {
            steps {
                echo 'Nexus Docker Repository Login'
                script {
                    withCredentials([usernamePassword(credentialsId: 'nexus_creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh "echo $PASS | docker login -u $USER --password-stdin $NEXUS_DOCKER_REPO"
                    }
                }
            }
        }

        stage('Docker Push') {
            steps {
                echo 'Pushing Image to Docker Repository'
                sh "docker push $NEXUS_DOCKER_REPO/maven-web-app:${BUILD_NUMBER}"
            }
        }

        stage('Docker Pull and Run') {
            steps {
                echo 'Pulling Image from Docker Repository'
                sh "docker pull $NEXUS_DOCKER_REPO/maven-web-app:${BUILD_NUMBER}"

                echo 'Running Docker Container'
                sh "docker run -d -p 80:8080 --name new-app $NEXUS_DOCKER_REPO/maven-web-app:${BUILD_NUMBER}"
            }
        }
    }
}
