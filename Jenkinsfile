pipeline {
    agent any

    options {
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    environment {
        // NVD_API_KEY can be provided globally via Jenkins > Manage Jenkins > System > Environment Variables
        // or via Jenkins credentials. Do NOT hardcode the key here.
        NVD_KEY_EXISTS = "${env.NVD_API_KEY ? 'Yes' : 'No'}"
    }

    stages {
        stage('Checkout') {
            steps {
                echo '=== Checkout Source Code ==='
                checkout scm
            }
        }

        stage('Show Environment') {
            steps {
                echo '=== Kiem tra moi truong Windows ==='
                bat 'java -version'
                bat 'mvn -version'
                echo "NVD_API_KEY Configured: ${NVD_KEY_EXISTS}"
            }
        }

        stage('Build') {
            steps {
                echo '=== Build ung dung Spring Boot (Bo qua test) ==='
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('SCA Scan Vulnerable') {
            steps {
                echo '=== Scan ban VULNERABLE (Log4j 2.14.1) ==='
                echo 'Mong doi stage nay se fail do CVSS >= 7 (Log4Shell).'
                catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                    bat 'mvn org.owasp:dependency-check-maven:check -Pvulnerable -DskipTests'
                }
            }
        }

        stage('Archive Vulnerable Report') {
            steps {
                echo '=== Luu tru bao cao Vulnerable ==='
                bat 'if not exist "reports\\before-fix" mkdir "reports\\before-fix"'
                bat 'if exist "target\\dependency-check-report.html" copy /Y "target\\dependency-check-report.html" "reports\\before-fix\\dependency-check-report.html"'
                
                archiveArtifacts artifacts: 'reports/before-fix/**', allowEmptyArchive: true
                archiveArtifacts artifacts: 'target/dependency-check-report.html', allowEmptyArchive: true, fingerprint: true
            }
        }

        stage('SCA Scan Fixed') {
            steps {
                echo '=== Scan ban FIXED (Log4j 2.24.3) ==='
                echo 'Mong doi stage nay se pass do da va loi.'
                bat 'mvn org.owasp:dependency-check-maven:check -Pfixed -DskipTests'
            }
        }

        stage('Archive Fixed Report') {
            steps {
                echo '=== Luu tru bao cao Fixed ==='
                bat 'if not exist "reports\\after-fix" mkdir "reports\\after-fix"'
                bat 'if exist "target\\dependency-check-report.html" copy /Y "target\\dependency-check-report.html" "reports\\after-fix\\dependency-check-report.html"'
                
                archiveArtifacts artifacts: 'reports/after-fix/**', allowEmptyArchive: true
                archiveArtifacts artifacts: 'target/dependency-check-report.html', allowEmptyArchive: true, fingerprint: true
            }
        }

        stage('Summary') {
            steps {
                echo '=== TONG KET PIPELINE ==='
                echo 'Quy trinh DevSecOps hoan tat. Kiem tra the Artifacts de tai bao cao.'
                echo 'Du kien: Pipeline Unstable do ban vulnerable chua ma doc.'
            }
        }
    }

    post {
        always {
            echo 'Don dep workspace (Tuy chon - hien tai giu lai de debug).'
        }
    }
}
