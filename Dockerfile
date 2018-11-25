FROM debian:stretch

MAINTAINER Joseph Weigl

USER root

# Install dependencies
RUN apt-get -yqq update && \
    apt-get -yqq --no-install-recommends install gnupg curl python ca-certificates libcap2-bin git-core build-essential mosquitto mosquitto-clients bluetooth bluez libbluetooth-dev libudev-dev rfkill && \
    apt-get -yqq autoremove && \
    apt-get -yqq clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/* /tmp/* /var/tmp/*

RUN curl -sL https://deb.nodesource.com/setup_9.x | bash - && apt-get install -y nodejs
RUN curl -L https://npmjs.org/install.sh | sh

RUN usermod -a -G bluetooth root && \
    setcap cap_net_raw+eip /usr/bin/node
	
RUN git clone https://github.com/espruino/EspruinoHub /var/espruinohub

WORKDIR /var/espruinohub

RUN npm install

RUN npm install bluetooth-hci-socket

#Run other commands for start BLE...
CMD BLENO_ADVERTISING_INTERVAL=300 NOBLE_MULTI_ROLE=1 node index.js

