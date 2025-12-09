pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = credentials('docker-registry-url')
        DOCKER_CREDENTIALS = credentials('docker-credentials-id')
        VERSION = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build & Push Eureka Server') {
            steps {
                script {
                    dir('microservices/eureka-server') {
                        docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-credentials-id') {
                            def image = docker.build("${DOCKER_REGISTRY}/eureka-server:${VERSION}")
                            image.push()
                            image.push('latest')
                        }
                    }
                }
            }
        }
        
        stage('Build & Push API Gateway') {
            steps {
                script {
                    dir('microservices/api-gateway') {
                        docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-credentials-id') {
                            def image = docker.build("${DOCKER_REGISTRY}/api-gateway:${VERSION}")
                            image.push()
                            image.push('latest')
                        }
                    }
                }
            }
        }
        
        stage('Build & Push User Service') {
            steps {
                script {
                    dir('microservices/user-service') {
                        docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-credentials-id') {
                            def image = docker.build("${DOCKER_REGISTRY}/user-service:${VERSION}")
                            image.push()
                            image.push('latest')
                        }
                    }
                }
            }
        }
        
        stage('Build & Push Movie Service') {
            steps {
                script {
                    dir('microservices/movie-service') {
                        docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-credentials-id') {
                            def image = docker.build("${DOCKER_REGISTRY}/movie-service:${VERSION}")
                            image.push()
                            image.push('latest')
                        }
                    }
                }
            }
        }
        
        stage('Build & Push Venue Service') {
            steps {
                script {
                    dir('microservices/venue-service') {
                        docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-credentials-id') {
                            def image = docker.build("${DOCKER_REGISTRY}/venue-service:${VERSION}")
                            image.push()
                            image.push('latest')
                        }
                    }
                }
            }
        }
        
        stage('Build & Push Booking Service') {
            steps {
                script {
                    dir('microservices/booking-service') {
                        docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-credentials-id') {
                            def image = docker.build("${DOCKER_REGISTRY}/booking-service:${VERSION}")
                            image.push()
                            image.push('latest')
                        }
                    }
                }
            }
        }
        
        stage('Build & Push Payment Service') {
            steps {
                script {
                    dir('microservices/payment-service') {
                        docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-credentials-id') {
                            def image = docker.build("${DOCKER_REGISTRY}/payment-service:${VERSION}")
                            image.push()
                            image.push('latest')
                        }
                    }
                }
            }
        }
        
        stage('Build & Push Frontend') {
            steps {
                script {
                    dir('frontend') {
                        docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-credentials-id') {
                            def image = docker.build("${DOCKER_REGISTRY}/frontend:${VERSION}")
                            image.push()
                            image.push('latest')
                        }
                    }
                }
            }
        }
        
        stage('Build & Push MySQL') {
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-credentials-id') {
                        sh '''
                            docker pull mysql:8.0
                            docker tag mysql:8.0 ${DOCKER_REGISTRY}/mysql:8.0
                            docker push ${DOCKER_REGISTRY}/mysql:8.0
                        '''
                    }
                }
            }
        }
        
        stage('Build & Push MongoDB') {
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-credentials-id') {
                        sh '''
                            docker pull mongo:latest
                            docker tag mongo:latest ${DOCKER_REGISTRY}/mongo:latest
                            docker push ${DOCKER_REGISTRY}/mongo:latest
                        '''
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
        always {
            cleanWs()
        }
    }
}
