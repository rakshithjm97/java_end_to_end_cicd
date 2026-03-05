pipeline
{
    agent any

    environment{
        SONAR_HOME = tool "Sonar"
        SONARCUBE_SERVER = "Sonar"
        DOCKERHUB_USER = "rakshithjm7"
    }


    parameters{
        string(name: 'DOCKER_FRONTEND_TAG', defaultValue: '', description: 'setting image tag for latest push')
        string(name: 'DOCKER_BACKEND_TAG', defaultValue: '', description: 'setting up the tag for latest push')

    }

    options{
        timestamps()
        ansiColor('xterm')
        disableConcurrentBuilds()

    }

    stages{
        stage('validate parameters'){
            steps{
                script{
                    if (!params.DOCKER_FRONTEND_TAG?.trim() || !params.DOCKER_BACKEND_TAG?.trim())
                    {
                        error("enter DOCKER_FRONTEND_TAG and DOCKER_BACKEND_TAG.")
                    }

                }
            }
        }

        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }


        stage('Git : code checkout'){
            steps{
                git branch: 'main', url: 'https://github.com/rakshithjm97/java_end_to_end_cicd.git'
                }
        }
        

        stage('Trivy : filesystem scan'){
            steps{
                sh '''
                set -e 
                trivy --version
                trivy fs --quiet --format json --output trivy-fs.json .
                '''

            }
        }

        stage('OWASP: dependency check'){
            steps{
                sh '''
                set -e 
                dependency-check --version 

                rm -rf odc-data
                mkdir -p odc-data odc-reports
                dependency-check --project "wanderlust" --scan . --format JSON --out odc-reports --data odc-data
                '''
            }
        }

        stage("SonarQube : code analysis"){
            steps{
                withSonarQubeEnv("${env.SONARCUBE_SERVER}"){
                    sh '''
                    set -e
                    "${env.SONAR_HOME}/bin/sonar-scanner" \
                    -Dsonar.projectKey=wanderlust \
                    -Dsonar.projectName=wanderlust \
                    -Dsonar.projectVersion=1.0 \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=${SONAR_HOST_URL} \
                    -Dsonar.login=${SONAR_AUTH_TOKEN}

                    '''
                }

            }

        }

        stage("SonarQube: code quality gates"){
            steps{
                timeout(time: 10, unit: 'MINUTES'){
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage("Exporting environment variables"){
            parallel{
                stage("backend environment setup"){
                    steps{
                        dir("automations"){
                            sh "bash updatebackend.sh"
                        }

                    }
                }
                stage("frontend environment setup"){
                    steps{
                        dir("automations"){
                            sh "bash updatefrontend.sh"
                        }
                    }
                }
            
            
            
            }
        }

        stage("build docker image"){
            steps{
                script{
                    sh '''
                    set -e
                    docker --version
                    cd backend
                    docker build -t backend:${params.DOCKER_BACKEND_TAG} .
                    cd ../frontend
                    docker build -t frontend:${params.DOCKER_FRONTEND_TAG} .

                    '''
                }
            }
        }


        stage("push to docker hub"){
            steps{
                script{
                    sh '''
                    set -e
                    echo "$DH_PASS" | docker login -u "$DH_USER" --password --stdin

                    docker push rakshithjm7/backend:${params.DOCKER_BACKEND_TAG}
                    docker push rakshithjm7/frontend:${params.DOCKER_FRONTEND_TAG}

                    docker logout

                    '''
                }
            }
        }
        
    }

    post {
        success{
            archiveArtifacts artifacts : '*.xml', followSymlinks : false

        }
    }





}
