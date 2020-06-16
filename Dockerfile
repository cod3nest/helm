FROM alpine

ENV HELM_VERSION="v3.2.1"

RUN apk --update add openssl curl bash && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh

ENV HELM_EXPERIMENTAL_OCI=1
