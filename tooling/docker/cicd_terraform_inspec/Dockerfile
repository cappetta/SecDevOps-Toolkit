FROM alpine:latest
MAINTAINER "Cappetta <cappetta@automatedcybersolutions.com>"

ENV TERRAFORM_VERSION=0.11.8
ENV TERRAFORM_SHA256SUM=84ccfb8e13b5fce63051294f787885b76a1fedef6bdbecf51c5e586c9e20c9b7

RUN apk add --update git curl openssh && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum -cs terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    ls -alrt /bin/ && \
    ls -alrt && \
    chmod 755 /bin/terraform && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN  apk update && \
  apk upgrade && \
  apk add curl wget bash git ruby ruby-bundler ruby ruby-dev make gcc libc-dev g++ ruby-rdoc && \
  rm -rf /var/cache/apk/*

RUN mkdir ~/git && \
  cd ~/git && \
  git clone https://github.com/inspec/inspec.git

RUN cd ~/git/inspec && \
    gem build inspec.gemspec && \
    gem install inspec-*.gem
RUN cd ~/git/inspec && \
 bundle install

ENTRYPOINT ["/bin/bash"]
