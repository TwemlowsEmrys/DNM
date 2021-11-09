#!/bin/bash
systemctl stop i2pd
#rm -rf /home/amnesia/.tor-browser/profile.default/prefs.js
#mv /home/amnesia/.tor-browser/profile.default/i2p_enabled_backup_prefs.js /home/amnesia/.tor-browser/profile.default/prefs.js
pkill python3
pkill http.server
sudo -u root /home/amnesia/.i2pd_script/tails-create-netns-i2p stop
sudo -u root /usr/local/lib/tails-create-netns start

echo '[-] I2P disabled.'

notify-send "I2P disabled"
