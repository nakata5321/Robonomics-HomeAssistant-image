#!/bin/bash -e

on_chroot << EOF

    useradd -rm homeassistant -d /srv/homeassistant -G docker

    cd /srv/homeassistant

    su homeassistant -c "git clone https://github.com/nakata5321/home-assistant-web3-build.git"
    cd home-assistant-web3-build/

    echo "# Provide Relay address for libp2p proxy
RELAY_ADDRESS=/dns4/libp2p-relay-1.robonomics.network/tcp/443/wss/p2p/12D3KooWEMFXXvpZUjAuj1eKR11HuzZTCQ5HmYG9MNPtsnqPSERD

#Optional:
# provide the path to the repository where docker will store all configuration
CONFIG_PATH=.
# provide your time zone in tz database name, like TZ=America/Los_Angeles
TZ=Europe/London
#Provide zigbee channel
ZIGBEE_CHANNEL=11

#Provide version of docker images
MOSQUITTO_VERSION=2.0.18
Z2M_VERSION=1.36.1
HA_VERSION=2024.4.4
ROBONOMICS_VERSION=1.8.2
IPFS_VERSION=0.27.0
    " | tee /srv/homeassistant/home-assistant-web3-build/.env

    cd /srv/homeassistant

    echo "#!/bin/bash

FILE=/srv/homeassistant/check

if [ -f $FILE ]; then
    echo "first initialization completed"
    exit 0
else
    echo "Start docker compose"

    cd /srv/homeassistant/home-assistant-web3-build
    bash setup.sh
    touch $FILE
    echo "Docker compose started"
fi
    " | tee /srv/homeassistant/dokcer_first_start.sh

    chmod a+x dokcer_first_start.sh
    mv dokcer_first_start.sh /usr/local/bin/

    echo "[Unit]
Description=Docker Compose Robonomics Service
After=network.target

[Service]
Type=simple
User=homeassistant
ExecStart=/usr/local/bin/dokcer_first_start.sh

[Install]
WantedBy=multi-user.target

  " | tee /etc/systemd/system/robonomics-start.service

  systemctl enable robonomics-start.service

EOF