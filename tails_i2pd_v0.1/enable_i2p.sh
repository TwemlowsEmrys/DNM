#!/bin/bash
cp /home/amnesia/.tor-browser/profile.default/prefs.js /home/amnesia/.tor-browser/profile.default/i2p_enabled_backup_prefs.js

pkill python3
pkill http.server
systemctl stop i2pd
sudo -u root /usr/local/lib/tails-create-netns stop

sudo -u root /home/amnesia/.i2pd_script/tails-create-netns-i2p start

sudo -u amnesia python3 -m http.server --bind 10.200.1.1 --directory /home/amnesia/Tor\ Browser/localhost-tbb-proxy-pac 8181 >/dev/null 2>&1 &

systemctl start i2pd

echo '[+] I2P enabled.'

echo '[+] Check the about:config setting "network.proxy.type" after every Tor Browser restart. It MUST be set to 2'

notify-send "I2P enabled"
notify-send 'Check the about:config setting "network.proxy.type" after every Tor Browser restart. It MUST be set to 2'
