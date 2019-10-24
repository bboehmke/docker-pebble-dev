FROM python:2-buster
MAINTAINER Benjamin Böhmke

# update system and get base packages
RUN apt-get update && \
    apt-get install -y curl libfreetype6-dev bash-completion libsdl1.2debian \
                       libfdt1 libpixman-1-0 libglib2.0-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# set the version of the pebble tool
ENV PEBBLE_TOOL_VERSION pebble-sdk-4.5-linux64
# set the version of pre installed
ENV PEBBLE_SDK_VERSION 4.3

# get pebble tool
RUN curl -sSL https://developer.rebble.io/s3.amazonaws.com/assets.getpebble.com/pebble-tool/${PEBBLE_TOOL_VERSION}.tar.bz2 \
        | tar -v -C /opt/ -xj

# prepare python environment 
WORKDIR /opt/${PEBBLE_TOOL_VERSION}
RUN /bin/bash -c " \
        virtualenv --no-site-packages .env && \
        source .env/bin/activate && \
        sed -i '/pypkjs/d' requirements.txt && \
        pip install -r requirements.txt https://github.com/Willow-Systems/vagrant-pebble-sdk/raw/master/pypkjs-1.0.6.tar.gz && \
        deactivate " && \
    rm -r /root/.cache/

# prepare pebble user for build environment + disable analytics
RUN adduser --disabled-password --gecos "" --ingroup users pebble && \
    echo "pebble ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    chmod -R 777 /opt/${PEBBLE_TOOL_VERSION} && \
    mkdir -p /home/pebble/.pebble-sdk/ && \
    chown -R pebble:users /home/pebble/.pebble-sdk && \
    touch /home/pebble/.pebble-sdk/NO_TRACKING

# change to pebble user
USER pebble

ENV NODE_VERSION 10.16.2

ENV NVM_DIR /home/pebble/.nvm

RUN mkdir -p $NVM_DIR && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh | bash && \
    . $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION

# set PATH
ENV PATH ${NVM_DIR}/versions/node/v${NODE_VERSION}/bin:/opt/${PEBBLE_TOOL_VERSION}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


# install sdk
RUN yes | pebble sdk install https://github.com/aveao/PebbleArchive/raw/master/SDKCores/sdk-core-${PEBBLE_SDK_VERSION}.tar.bz2 && \
    pebble sdk activate ${PEBBLE_SDK_VERSION}

# prepare project mount path
VOLUME /pebble/

# set run command
WORKDIR /pebble/
CMD /bin/bash
