ARG _FROM_IMAGE=registry.access.redhat.com/ubi8/ubi
ARG _FROM_TAG=latest
FROM ${_FROM_IMAGE}:${_FROM_TAG}

ARG _BUILD_PROXY_URL
ARG _BUILD_CACERTDIR
ARG _HELM_VER
ARG _OC_VER

RUN mkdir -p /root/cacerts
COPY ./${_BUILD_CACERTDIR}/ /root/cacerts/

RUN yum update -y && \
  yum install -y --exclude container-selinux \
    ca-certificates \
    curl \
    git \
    iputils \
    jq \
    redhat-lsb-core \
    libicu \
    gnupg \
    podman \
    buildah \
    skopeo \
    fuse-overlayfs && \
  rm -rf /var/cache /var/log/dnf* /var/log/yum.* && \
  sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' /etc/containers/storage.conf && \
  mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers && \
  touch /var/lib/shared/overlay-images/images.lock /var/lib/shared/overlay-layers/layers.lock
RUN (shopt -s nullglob && [ -z /root/cacerts/* ] || for cacert in /root/cacerts/*; do echo "Adding CA cert $cacert" && cp "$cacert"  /etc/pki/ca-trust/source/anchors/; done)
RUN update-ca-trust && \
  mkdir -p /usr/local/bin && \
  mkdir -p /tmp/dl && \
  env https_proxy="${_BUILD_PROXY_URL}" curl -sLo /tmp/dl/helm.tar.gz "https://get.helm.sh/helm-v${_HELM_VER}-linux-amd64.tar.gz" && \
  env https_proxy="${_BUILD_PROXY_URL}" curl -sLo /tmp/dl/oc.tar.gz "https://mirror.openshift.com/pub/openshift-v4/amd64/clients/ocp/${_OC_VER}/openshift-client-linux.tar.gz" && \
  tar xfC /tmp/dl/helm.tar.gz /tmp/dl && \
  cp /tmp/dl/linux-amd64/helm /usr/local/bin/helm && \
  tar xfC /tmp/dl/oc.tar.gz /tmp/dl && \
  cp /tmp/dl/oc /usr/local/bin/oc && \
  ln /usr/local/bin/oc /usr/local/bin/kubectl && \
  echo -n 'helm version: ' && helm version --short && \
  echo -n 'oc version: ' && oc version --client && \
  rm -rf /tmp/dl

ENV _BUILDAH_STARTED_IN_USERNS="" BUILDAH_ISOLATION=chroot
ENV TARGETARCH=linux-x64

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USER_NAME=agent
ARG GROUP_NAME=agent
ARG USER_HOME=/azp
RUN groupadd -g "${GROUP_ID}" "${GROUP_NAME}" && \
  useradd -g "${GROUP_ID}" -u "${USER_ID}" -d "${USER_HOME}" -s /bin/bash -c 'Agent' "${USER_NAME}"
WORKDIR /azp
COPY ./start.sh .
RUN chown "${USER_ID}:${GROUP_ID}" start.sh && chmod +x start.sh

ENTRYPOINT [ "./start.sh" ]
