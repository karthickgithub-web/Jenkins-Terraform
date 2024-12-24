pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    agent any
    stages {
        stage('Checkout') {
            steps {
                // Option 1: Using the 'checkout' step (Recommended)
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/karthickgithub-web/Jenkins-Terraform.git']]])
                // Option 2: Using 'sh' command for cloning (Alternative)
                // sh 'git clone https://github.com/karthickgithub-web/Jenkins-Terraform.git terraform'

            }
        }

        stage('Plan') {
            steps {
                sh 'pwd; cd terraform/; terraform init'
                sh 'pwd; cd terraform/; terraform plan -out tfplan'
                sh 'pwd; cd terraform/; terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }
            steps {
                script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                          parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply') {
            steps {
                sh 'pwd; cd terraform/; terraform apply -input=false tfplan'
            }
        }
    }
}
