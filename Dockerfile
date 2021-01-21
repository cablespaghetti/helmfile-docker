FROM hashicorp/terraform:0.14.5 AS terraform

FROM debian:buster-slim

ARG KUBECTL_VERSION=1.18.9
ARG HELM_VERSION=3.5.0
ARG HELM_DIFF_VERSION=3.1.3
ARG HELM_SECRETS_VERSION=2.0.2
ARG HELMFILE_VERSION=0.137.0
ARG HELM_S3_VERSION=0.10.0
ARG HELM_GIT_VERSION=0.8.1

WORKDIR /

RUN apt-get update && apt-get install -y git gnupg curl gettext jq unzip sudo python3-pip
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.1.19.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm -rf aws awscliv2.zip \
  && rm -rf ./aws \
  && rm -rf /var/lib/apt/lists
RUN aws --version
RUN pip3 install ec2instanceconnectcli
RUN mssh -h
ADD https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl
RUN kubectl version --client

ADD https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/amd64/aws-iam-authenticator /usr/local/bin/aws-iam-authenticator
RUN chmod +x /usr/local/bin/aws-iam-authenticator
RUN aws-iam-authenticator version

ADD https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz /tmp
RUN tar -zxvf /tmp/helm* -C /tmp \
  && mv /tmp/linux-amd64/helm /bin/helm \
  && rm -rf /tmp/*
RUN helm version

RUN helm plugin install https://github.com/databus23/helm-diff --version ${HELM_DIFF_VERSION} && \
    helm plugin install https://github.com/futuresimple/helm-secrets --version ${HELM_SECRETS_VERSION} && \
    helm plugin install https://github.com/hypnoglow/helm-s3.git --version ${HELM_S3_VERSION} && \
    helm plugin install https://github.com/aslafy-z/helm-git --version ${HELM_GIT_VERSION}

ADD https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64 /bin/helmfile
RUN chmod 0755 /bin/helmfile
RUN helmfile version

COPY --from=terraform /bin/terraform /bin/terraform
RUN terraform version

ENTRYPOINT ["/bin/helmfile"]
