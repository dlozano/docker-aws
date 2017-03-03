# Based on cgswong/aws
FROM buildpack-deps:jessie-scm
MAINTAINER David Lozano <david@kantox.com>

ENV S3_TMP /tmp/s3cmd.zip
ENV S3_ZIP /tmp/s3cmd-master
ENV RDS_TMP /tmp/RDSCLi.zip
ENV RDS_VERSION 1.19.004
ENV JAVA_HOME /usr/lib/jvm/default-jvm
ENV AWS_RDS_HOME /usr/local/RDSCli-${RDS_VERSION}
ENV PATH ${PATH}:${AWS_RDS_HOME}/bin:${JAVA_HOME}/bin:${AWS_RDS_HOME}/bin
ENV PAGER more

WORKDIR /tmp

RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates && \
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list && \
    apt-get update

RUN apt-get install -y \
      bash \
      bash-completion \
      groff \
      less \
      curl \
      jq \
      python-pip \
      python \
      unzip \
      docker \
      docker-engine=1.11.2-0~jessie && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sSL https://github.com/harbur/captain/releases/download/v1.1.0/captain_linux_amd64 > /usr/bin/captain && \
    chmod +x /usr/bin/captain && \
    curl -sSL https://storage.googleapis.com/kubernetes-release/release/v1.5.1/bin/linux/amd64/kubectl > /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl && \
    pip install --upgrade \
      awscli \
      pip \
      python-dateutil &&\
    ln -s /usr/bin/aws_bash_completer /etc/profile.d/aws_bash_completer.sh &&\
    curl -sSL --output ${S3_TMP} https://github.com/s3tools/s3cmd/archive/master.zip &&\
    curl -sSL --output ${RDS_TMP} http://s3.amazonaws.com/rds-downloads/RDSCli.zip &&\
    unzip -q ${S3_TMP} -d /tmp &&\
    unzip -q ${RDS_TMP} -d /tmp &&\
    mv ${S3_ZIP}/S3 ${S3_ZIP}/s3cmd /usr/bin/ &&\
    mv /tmp/RDSCli-${RDS_VERSION} /usr/local/ &&\
    rm -rf /tmp/* &&\
    mkdir ~/.aws &&\
    chmod 700 ~/.aws

COPY update_secret.bash docker-credential-ecr-login /usr/bin/

# AWS credentials must be provided via ENV variables
#
#
# Provide a volume in /var/run/docker.sock if you want
# to interact with the node docker
#
#
CMD ["/bin/bash", "--login"]

