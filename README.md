# local-jenkins

## Install dind image

```bash
docker run --name jenkins-docker --detach --rm \
  --privileged --network jenkins --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind --storage-driver overlay2
```

## Build jenkins image

`docker buildx build -t jenkins-local .`

## Run jenkins container

```bash
docker run --name jenkins-local --restart=on-failure --detach \
  --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-local:latest
```

## Access Jenkins admin password

After running the container, jenkins will ask for initial password.

Execute the following command to access container shell.



Get the password with the following command.

`cat /var/lib/jenkins/secrets/initialAdminPassword`