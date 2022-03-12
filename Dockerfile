FROM ubuntu:20.04
ARG TARGETPLATFORM

ARG USER
ARG USER_ID

ENV AWSCLI_VERSION=${AWSCLI_VERSION:-2.4.3}
# ENV TERRAFORM_VERSION=${TERRAFORM_VERSION:-0.14.0}
ENV TERRAFORM_VERSION=${TERRAFORM_VERSION:-1.0.0}
# ENV TERRAFORM_VERSION=${TERRAFORM_VERSION:-0.12.7}
ENV TERRAGRUNT_VERSION=${TERRAGRUNT_VERSION:-0.35.5}
ENV TERRAFORMDOCS_VERSION=${TERRAFORMDOCS_VERSION:-0.16.0}
ENV KUBECTL_VERSION=${KUBECTL_VERSION:-1.22.4}
ENV KUBECTX_VERSION=${KUBECTX_VERSION:-0.9.4}

ENV TZ=Europe/Madrid

RUN echo "I'm building for $TARGETPLATFORM"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
  echo $TZ > /etc/timezone

RUN apt update && \
  apt install -y \
  bsdmainutils \
  curl \
  git \
  # graphviz \
  iputils-ping \
  python3-pip \
  python3 \
  tree \
  vim \
  jq \
  unzip && \
  rm -rf /var/lib/apt/lists/*

#pip
RUN python3 -m pip install --upgrade pip && pip check
COPY requirements.txt ./
RUN pip --no-cache-dir install -r requirements.txt

# AWS CLI V2

RUN curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip" -o "awscliv2.zip" && \
  unzip awscliv2.zip && \
  ./aws/install && \
  rm awscliv2.zip; 


  RUN curl -sL https://raw.githubusercontent.com/jonmosco/kube-ps1/master/kube-ps1.sh -o /usr/local/bin/kube-ps1.sh && \
  chmod +x /usr/local/bin/kube-ps1.sh

RUN useradd -m -u $USER_ID $USER

USER $USER

RUN echo "alias ll='ls -la'" >> ~/.bashrc && \
  echo "source /usr/local/bin/kube-ps1.sh" >> ~/.bashrc &&  \
  echo "source /usr/share/bash-completion/completions/git" >> ~/.bashrc &&  \
  echo "PATH=$PATH:~/bin:/usr/local/bin/aws_completer" >> ~/.bashrc && \
  echo "PS1='\u@\h:\w \$(kube_ps1)[\e[0;33m\$(git branch 2>/dev/null | grep '^*'| colrm 1 2)\e[m]\$ '" >> ~/.bashrc

WORKDIR /app

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
