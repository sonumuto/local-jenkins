FROM jenkins/jenkins:jdk21

USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=SC2086
RUN apt-get update && apt-get install --no-install-recommends -y lsb-release=12.0* ca-certificates=20230311 curl=7.88.1* && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/debian $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install --no-install-recommends -y docker-ce-cli=5:28.1.1* && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER jenkins

RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
