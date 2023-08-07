#!/bin/bash -e

on_chroot << EOF

    useradd -rm homeassistant -d /srv/homeassistant -G dialout,tty

    cd /srv/homeassistant

    su homeassistant -c "python3 -m venv ."

    su homeassistant -c bash -c "source bin/activate && pip3 install wheel"

    su homeassistant -c bash -c "source bin/activate && pip3 install sqlalchemy fnvhash aiodiscover"

    su homeassistant -c bash -c "source bin/activate && pip3 install homeassistant psutil-home-assistant"

    install -d  /srv/homeassistant/.homeassistant/
    chown homeassistant:homeassistant /srv/homeassistant/.homeassistant/

    install -d  /srv/homeassistant/.homeassistant/media/
    chown homeassistant:homeassistant /srv/homeassistant/.homeassistant/media/

EOF