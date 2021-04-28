# Helmfile Docker

A Docker image containing [Helm](https://github.com/helm/helm), [Helmfile](https://github.com/roboll/helmfile) and a number of Helm plugins:

  - [helm-diff](https://github.com/databus23/helm-diff)
  - [helm-secrets](https://github.com/jkroepke/helm-secrets)
  - [helm-s3](https://github.com/hypnoglow/helm-s3)
  - [helm-git](https://github.com/aslafy-z/helm-git)

It also includes kubectl and the aws-iam-authenticator, so it works with Amazon EKS.

It is built with Docker Hub Builds and pushed to [cablespaghetti/helmfile-docker](https://hub.docker.com/r/cablespaghetti/helmfile-docker)
