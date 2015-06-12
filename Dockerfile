FROM ubuntu:14.04
MAINTAINER Benjamin Böhmke

# set the version of the pebble sdk
ENV PEBBLE_VERSION PebbleSDK-3.0

# update system and get base packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl python2.7-dev python-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# get pebble SDK
RUN curl -sSL http://assets.getpebble.com.s3-website-us-east-1.amazonaws.com/sdk2/$PEBBLE_VERSION.tar.gz \
        | tar -v -C /opt -xz

# get arm tools
RUN curl -sSL http://assets.getpebble.com.s3-website-us-east-1.amazonaws.com/sdk/arm-cs-tools-ubuntu-universal.tar.gz \
        | tar -v -C /opt/$PEBBLE_VERSION -xz

# prepare python environment 
WORKDIR /opt/$PEBBLE_VERSION
RUN /bin/bash -c " \
    pip install virtualenv \
    && virtualenv --no-site-packages .env \
    && source .env/bin/activate \
    && pip install -r requirements.txt \
    && deactivate \
    "

# prepare pebble user for build environment
RUN adduser --disabled-password --gecos "" --ingroup users pebble && \
    echo "pebble ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo "export PATH=/opt/$PEBBLE_VERSION/bin:$PATH" >> /home/pebble/.bashrc && \
    chmod -R 777 /opt/

# change to pebble user
USER pebble

# prepare project mount path
VOLUME /pebble/

# set run command
WORKDIR /pebble/
CMD /bin/bash