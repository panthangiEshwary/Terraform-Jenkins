pipeline {
  agent any

  environment {
    AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')

    TF_VAR_aws_region        = "us-east-1"
    TF_VAR_availability_zone = "us-east-1a"
    TF_VAR_vpc_cidr          = "10.0.0.0/16"
    TF_VAR_subnet_cidr       = "10.0.1.0/24"
    TF_VAR_instance_type     = "t2.micro"
    TF_VAR_ami_id            = "ami-020cba7c55df1f615"
  }

  parameters {
    booleanParam(name: 'APPLY_INFRA', defaultValue: false, description: 'Apply the Terraform plan?')
    booleanParam(name: 'DESTROY_INFRA', defaultValue: false, description: 'Destroy the infrastructure?')
  }

  stages {
    stage('Init') {
      steps {
        echo "Running terraform init..."
        sh 'terraform init'
      }
    }

    stage('Validate') {
      steps {
        echo "Validating Terraform code..."
        sh 'terraform validate'
      }
    }

    stage('Plan') {
      steps {
        echo "Generating Terraform plan..."
        sh 'terraform plan -out=tfplan'
        sh 'terraform show -no-color tfplan > plan.txt'
        archiveArtifacts artifacts: 'plan.txt', fingerprint: true
      }
    }

    stage('Apply') {
      when {
        expression { return params.APPLY_INFRA == true }
      }
      steps {
        echo "Applying infrastructure changes..."
        sh 'terraform apply -auto-approve tfplan'
      }
    }

    stage('Destroy') {
      when {
        expression { return params.DESTROY_INFRA == true }
      }
      steps {
        echo "Destroying infrastructure..."
        sh 'terraform destroy -auto-approve'
      }
    }
  }

  post {
    always {
      echo "Pipeline execution completed."
    }
  }
}
