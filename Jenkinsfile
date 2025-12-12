pipeline {
    agent any
    
    environment {
        DOCKER_HUB_USERNAME = credentials('docker-hub-username') // Add your Docker Hub username in Jenkins credentials
        DOCKER_HUB_PASSWORD = credentials('docker-hub-password') // Add your Docker Hub password in Jenkins credentials
        DOCKER_REGISTRY = 'docker.io'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '=== Checking out code from Git ==='
                checkout scm
            }
        }
        
        stage('Build Maven Services') {
            parallel {
                stage('Build Eureka Server') {
                    steps {
                        dir('microservices/eureka-server') {
                            script {
                                if (isUnix()) {
                                    sh 'mvn clean package -DskipTests'
                                } else {
                                    bat 'mvn clean package -DskipTests'
                                }
                            }
                        }
                    }
                }
                stage('Build API Gateway') {
                    steps {
                        dir('microservices/api-gateway') {
                            script {
                                if (isUnix()) {
                                    sh 'mvn clean package -DskipTests'
                                } else {
                                    bat 'mvn clean package -DskipTests'
                                }
                            }
                        }
                    }
                }
                stage('Build User Service') {
                    steps {
                        dir('microservices/user-service') {
                            script {
                                if (isUnix()) {
                                    sh 'mvn clean package -DskipTests'
                                } else {
                                    bat 'mvn clean package -DskipTests'
                                }
                            }
                        }
                    }
                }
                stage('Build Movie Service') {
                    steps {
                        dir('microservices/movie-service') {
                            script {
                                if (isUnix()) {
                                    sh 'mvn clean package -DskipTests'
                                } else {
                                    bat 'mvn clean package -DskipTests'
                                }
                            }
                        }
                    }
                }
                stage('Build Venue Service') {
                    steps {
                        dir('microservices/venue-service') {
                            script {
                                if (isUnix()) {
                                    sh 'mvn clean package -DskipTests'
                                } else {
                                    bat 'mvn clean package -DskipTests'
                                }
                            }
                        }
                    }
                }
                stage('Build Booking Service') {
                    steps {
                        dir('microservices/booking-service') {
                            script {
                                if (isUnix()) {
                                    sh 'mvn clean package -DskipTests'
                                } else {
                                    bat 'mvn clean package -DskipTests'
                                }
                            }
                        }
                    }
                }
                stage('Build Payment Service') {
                    steps {
                        dir('microservices/payment-service') {
                            script {
                                if (isUnix()) {
                                    sh 'mvn clean package -DskipTests'
                                } else {
                                    bat 'mvn clean package -DskipTests'
                                }
                            }
                        }
                    }
                }
            }
        }
        
        stage('Docker Login') {
            steps {
                script {
                    echo '=== Logging into Docker Hub ==='
                    if (isUnix()) {
                        sh 'echo $DOCKER_HUB_PASSWORD | docker login -u $DOCKER_HUB_USERNAME --password-stdin'
                    } else {
                        bat 'docker login -u %DOCKER_HUB_USERNAME% -p %DOCKER_HUB_PASSWORD%'
                    }
                }
            }
        }
        
        stage('Build and Push Docker Images') {
            parallel {
                stage('Eureka Server') {
                    steps {
                        script {
                            echo '=== Building Eureka Server Image ==='
                            dir('microservices/eureka-server') {
                                if (isUnix()) {
                                    sh """
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-eureka:latest .
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-eureka:${IMAGE_TAG} .
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-eureka:latest
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-eureka:${IMAGE_TAG}
                                    """
                                } else {
                                    bat """
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-eureka:latest .
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-eureka:${IMAGE_TAG} .
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-eureka:latest
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-eureka:${IMAGE_TAG}
                                    """
                                }
                            }
                        }
                    }
                }
                stage('API Gateway') {
                    steps {
                        script {
                            echo '=== Building API Gateway Image ==='
                            dir('microservices/api-gateway') {
                                if (isUnix()) {
                                    sh """
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-gateway:latest .
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-gateway:${IMAGE_TAG} .
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-gateway:latest
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-gateway:${IMAGE_TAG}
                                    """
                                } else {
                                    bat """
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-gateway:latest .
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-gateway:${IMAGE_TAG} .
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-gateway:latest
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-gateway:${IMAGE_TAG}
                                    """
                                }
                            }
                        }
                    }
                }
                stage('User Service') {
                    steps {
                        script {
                            echo '=== Building User Service Image ==='
                            dir('microservices/user-service') {
                                if (isUnix()) {
                                    sh """
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-user:latest .
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-user:${IMAGE_TAG} .
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-user:latest
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-user:${IMAGE_TAG}
                                    """
                                } else {
                                    bat """
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-user:latest .
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-user:${IMAGE_TAG} .
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-user:latest
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-user:${IMAGE_TAG}
                                    """
                                }
                            }
                        }
                    }
                }
                stage('Movie Service') {
                    steps {
                        script {
                            echo '=== Building Movie Service Image ==='
                            dir('microservices/movie-service') {
                                if (isUnix()) {
                                    sh """
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-movie:latest .
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-movie:${IMAGE_TAG} .
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-movie:latest
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-movie:${IMAGE_TAG}
                                    """
                                } else {
                                    bat """
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-movie:latest .
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-movie:${IMAGE_TAG} .
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-movie:latest
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-movie:${IMAGE_TAG}
                                    """
                                }
                            }
                        }
                    }
                }
                stage('Venue Service') {
                    steps {
                        script {
                            echo '=== Building Venue Service Image ==='
                            dir('microservices/venue-service') {
                                if (isUnix()) {
                                    sh """
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-venue:latest .
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-venue:${IMAGE_TAG} .
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-venue:latest
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-venue:${IMAGE_TAG}
                                    """
                                } else {
                                    bat """
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-venue:latest .
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-venue:${IMAGE_TAG} .
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-venue:latest
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-venue:${IMAGE_TAG}
                                    """
                                }
                            }
                        }
                    }
                }
                stage('Booking Service') {
                    steps {
                        script {
                            echo '=== Building Booking Service Image ==='
                            dir('microservices/booking-service') {
                                if (isUnix()) {
                                    sh """
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-booking:latest .
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-booking:${IMAGE_TAG} .
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-booking:latest
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-booking:${IMAGE_TAG}
                                    """
                                } else {
                                    bat """
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-booking:latest .
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-booking:${IMAGE_TAG} .
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-booking:latest
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-booking:${IMAGE_TAG}
                                    """
                                }
                            }
                        }
                    }
                }
                stage('Payment Service') {
                    steps {
                        script {
                            echo '=== Building Payment Service Image ==='
                            dir('microservices/payment-service') {
                                if (isUnix()) {
                                    sh """
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-payment:latest .
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-payment:${IMAGE_TAG} .
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-payment:latest
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-payment:${IMAGE_TAG}
                                    """
                                } else {
                                    bat """
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-payment:latest .
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-payment:${IMAGE_TAG} .
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-payment:latest
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-payment:${IMAGE_TAG}
                                    """
                                }
                            }
                        }
                    }
                }
                stage('Frontend') {
                    steps {
                        script {
                            echo '=== Building Frontend Image ==='
                            dir('frontend') {
                                if (isUnix()) {
                                    sh """
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-frontend:latest .
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-frontend:${IMAGE_TAG} .
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-frontend:latest
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-frontend:${IMAGE_TAG}
                                    """
                                } else {
                                    bat """
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-frontend:latest .
                                        docker build -t ${DOCKER_HUB_USERNAME}/revtickets-frontend:${IMAGE_TAG} .
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-frontend:latest
                                        docker push ${DOCKER_HUB_USERNAME}/revtickets-frontend:${IMAGE_TAG}
                                    """
                                }
                            }
                        }
                    }
                }
            }
        }
        
        stage('Cleanup') {
            steps {
                script {
                    echo '=== Cleaning up Docker images ==='
                    if (isUnix()) {
                        sh 'docker system prune -f'
                    } else {
                        bat 'docker system prune -f'
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo '=== Pipeline executed successfully! ==='
            echo "All images have been pushed to Docker Hub with tags 'latest' and '${IMAGE_TAG}'"
        }
        failure {
            echo '=== Pipeline failed! ==='
        }
        always {
            script {
                if (isUnix()) {
                    sh 'docker logout'
                } else {
                    bat 'docker logout'
                }
            }
        }
    }
}
