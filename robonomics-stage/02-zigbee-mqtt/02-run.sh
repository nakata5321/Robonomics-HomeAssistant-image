#!/bin/bash -e

on_chroot << EOF

  install -d /opt/zigbee2mqtt
  chown -R homeassistant: /opt/zigbee2mqtt

  su homeassistant -c "git clone --depth 1 --branch 1.28.4 https://github.com/Koenkk/zigbee2mqtt.git /opt/zigbee2mqtt"

  cd /opt/zigbee2mqtt
  su homeassistant -c "npm ci"
EOF