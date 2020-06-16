#!/usr/bin/env groovy
properties([
        buildDiscarder(
                logRotator(numToKeepStr: "10", daysToKeepStr: "30", artifactDaysToKeepStr: "7", artifactNumToKeepStr: "1")
        )
])

def label = "worker-${UUID.randomUUID().toString()}"

def GIT_COMMIT_EMAIL
def GIT_COMMIT_MESSAGE
def GIT_COMMIT

try {
    podTemplate(
            label: label,
            containers: [
                    containerTemplate(name: "jnlp", image: "jenkins/inbound-agent", resourceRequestCpu: "500m", resourceLimitCpu: "1000m", resourceRequestMemory: "200Mi", resourceLimitMemory: "1000Mi"),
            ],
            volumes: [
                    hostPathVolume(hostPath: "/var/run/docker.sock", mountPath: "/var/run/docker.sock"),
            ],
            idleMinutes: 5
    ) {
        node {
            stage("Checkout") {
                gitData = checkout(
                        changelog: true,
                        poll: true,
                        scm: [
                                $class              : "GitSCM",
                                branches            : scm.branches,
                                filterChangelog     : false,
                                userRemoteConfigs   : [[credentialsId: "gitlab-ssh-key", url: "git@gitlab.com:codenest-ltd/infrastructure/helm.git"]]
                        ])
                GIT_COMMIT_EMAIL = sh(script: "git --no-pager show -s --format=\"%ae\"", returnStdout: true).trim()
                GIT_COMMIT_MESSAGE = sh(script: "git --no-pager show -s --format=\"%s\"", returnStdout: true).trim()
                GIT_COMMIT = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
            }

            stage('Build docker image') {
                container('docker') {
                    sh "docker build -t helm ."
                }
            }

        }
    }

    currentBuild.result = "SUCCESS"
    slackSend color: "good", message: "Build passed"
} catch (e) {
    println("Failure" + e.getMessage())
    currentBuild.result = "FAILURE"
    throw e
    slackSend color: "bad", message: "Build failed, $e"
}
