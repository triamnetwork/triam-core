# Use ubuntu image
FROM ubuntu:16.04

# install necessary dependencies
RUN apt-get update
RUN apt-get install software-properties-common python-software-properties
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update
RUN apt-get install -y git build-essential pkg-config autoconf automake libtool bison flex libpq-dev clang++-3.5 gcc-4.9 g++-4.9 cpp-4.9 curl unzip
RUN apt-get install -y pandoc

COPY ./ /usr/local/arm-core-bin

WORKDIR /usr/local/arm-core-bin

RUN git submodule init
RUN git submodule update

RUN ./autogen.sh
RUN ./configure
RUN make

# config ports
EXPOSE 11625
EXPOSE 11626

#RUN chmod 555 ./init-core.sh

#install and set-up aws-cli
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
    unzip awscli-bundle.zip

RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

CMD ["/usr/local/arm-core/config/init-core.sh"]
