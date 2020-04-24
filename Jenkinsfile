#!groovy

@Library('github.com/ayudadigital/jenkins-pipeline-library@v5.0.0') _

// Initialize global config
cfg = jplConfig('duing', 'docker', '', [email: env.CI_NOTIFY_EMAIL_TARGETS])

/**
 * Build and publish docker images
 *
 * @param nextReleaseNumber String Release number to be used as tag
 */
def buildAndPublishDockerImage(nextReleaseNumber = "") {
    if (nextReleaseNumber == "") {
        nextReleaseNumber = sh (script: "kd get-next-release-number .", returnStdout: true).trim().substring(1)
    }
    docker.withRegistry("", 'docker-token') {
        def customImage = docker.build("${env.DOCKER_ORGANIZATION}/duing:${nextReleaseNumber}", "--pull --no-cache duing")
        customImage.push()
        if (nextReleaseNumber != "beta") {
            customImage.push('latest')
            customImage.push('18.04')
        }
    }
}

pipeline {
    agent { label 'docker' }

    stages {
        stage ('Initialize') {
            steps  {
                jplStart(cfg)
            }
        }
        stage ('Build') {
            steps {
                buildAndPublishDockerImage("beta")
            }
        }
        stage ('Make release') {
            when { branch 'release/new' }
            steps {
                buildAndPublishDockerImage()
                jplMakeRelease(cfg, true)
                deleteDir()
            }
        }
    }

    post {
        always {
            jplPostBuild(cfg)
        }
    }

    options {
        timestamps()
        ansiColor('xterm')
        buildDiscarder(logRotator(artifactNumToKeepStr: '20',artifactDaysToKeepStr: '30'))
        disableConcurrentBuilds()
        timeout(time: 60, unit: 'MINUTES')
    }
}
