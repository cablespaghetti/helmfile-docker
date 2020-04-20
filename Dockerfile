FROM alpine:3.11

ARG KUBECTL_VERSION=1.15.11
ARG HELM_VERSION=3.1.2
ARG HELM_DIFF_VERSION=3.1.1
ARG HELM_SECRETS_VERSION=2.0.2
ARG HELMFILE_VERSION=0.111.0
ARG HELM_S3_VERSION=0.9.2

WORKDIR /

RUN apk --update --no-cache add bash ca-certificates git gnupg curl gettext python3 jq && pip3 install gitpython~=2.1.11 requests~=2.22.0 PyYAML~=5.1.1 awscli

ADD https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

ADD https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/aws-iam-authenticator /usr/local/bin/aws-iam-authenticator
RUN chmod +x /usr/local/bin/aws-iam-authenticator

ADD https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz /tmp
RUN tar -zxvf /tmp/helm* -C /tmp \
  && mv /tmp/linux-amd64/helm /bin/helm \
  && rm -rf /tmp/*

RUN helm plugin install https://github.com/databus23/helm-diff --version ${HELM_DIFF_VERSION} && \
    helm plugin install https://github.com/futuresimple/helm-secrets --version ${HELM_SECRETS_VERSION} && \
    helm plugin install https://github.com/hypnoglow/helm-s3.git --version ${HELM_S3_VERSION}

ADD https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64 /bin/helmfile
RUN chmod 0755 /bin/helmfile

ENTRYPOINT ["/bin/helmfile"]
