#!/bin/bash -e

on_chroot << EOF

  echo "listener 1883
  allow_anonymous false
  password_file /etc/mosquitto/passwd" | tee /etc/mosquitto/conf.d/local.conf

  chmod o=rwx /etc/mosquitto/
EOF