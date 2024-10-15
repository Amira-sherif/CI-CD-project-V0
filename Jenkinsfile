// pipeline {
//     agent any
//     // environment {
//     //     AWS_ACCESS_KEY_ID     = credentials('aws-access')  // 'aws-access-key' is the ID you gave while storing the credentials
//     //     AWS_SECRET_ACCESS_KEY = credentials('aws-access')  // If you stored access key and secret key separately
//     //  }
//         stages {
            
//             stage('Checkout') {
//                 steps {
//                      git branch: 'main', credentialsId: 'git-token', url: 'https://github.com/Amira-sherif/https://github.com/Amira-sherif/CI-CD-project-V0/'
//                      }
//             }
//             stage('Check Terraform') {
//               steps {
//                   sh 'terraform --version'
//                      }
                
//             }
//             stage('init Terraform') {
//             steps {
//                 sh 'terraform init'
//                     }
//                                 }    
                
//           stage('Terraform apply') {
//                 steps {
//                  sh 'terraform apply  --auto-approve'
//                       }
//                                   }
//           stage('cp files to remote server') {
//                 steps {
//                  sh 'scp -r /var/lib/jenkins/workspace/ansible-pipe/* root@18.212.149.45:~/project
// '
//                       }
//                                   }
//           stage('apply ansible-playbook') {
//                 steps {
//                  sh 'ansible-playbook /var/lib/jenkins/deployment.yml'
//                       }
//                                   }
pipeline {
    agent {label 'slave'}

    stages {
        stage('prep') {
            steps {
                git 'https://github.com/Amira-sherif/CI-CD-project-V0.git'
            }
        }
        stage('build') {
            steps {
                withCredentials([usernamePassword(credentialsId:"docker",usernameVariable:"USER",passwordVariable:"PASS")]){
                sh 'docker build . -f dockerfile -t ${USER}/nodejs-iamge-yat225:v1.${BUILD_NUMBER}'
                }
            }
        }
    }
    post {
        success {
            withCredentials([usernamePassword(credentialsId:"docker",usernameVariable:"USER",passwordVariable:"PASS")]){
                sh 'docker login -u ${USER} -p ${PASS}'
                sh 'docker push ${USER}/nodejs-iamge:v1.${BUILD_NUMBER}'
                slackSend(
                channel: "devops",
                color: "good",
                message: "${env.JOB_NAME} is successeded. Build no. ${env.BUILD_NUMBER} (<https://hub.docker.com/repository/docker/${USER}/nodejs-iamge/general|Open the image link>)"
            )
                sh 'docker rm -f $(docker ps -aq)'
                sh 'docker run -d -p 3000:3000 ${USER}/nodejs-iamge:v1.${BUILD_NUMBER}'
            }
        }
        failure {
            slackSend(
                channel: "devops",
                color: "danger",
                message: "${env.JOB_NAME} is failed. Build no. ${env.BUILD_NUMBER} URL: ${env.BUILD_URL} (<${env.BUILD_URL}|Open the pipeline>)"
            )
        }
    }
}
