#!/bin/bash

CURRENTDIR=$(pwd)

# Script needs to be run as root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo ""
    echo "Script has failed to run. You must execute this as root."
    echo "--------------------------------------------------------"
    echo "                                                        "
    echo "Follow instructions for enabling root account on Tails OS (live or persistance):"
    echo ""
    echo "WARNING: You must be on the Welcome Screen before you login to Tails, this will not work while already logged in."
    echo ""
    echo "1. When the Welcome Screen appears, click on the Add Additional Setting (it is a plus looks like this -> + ) button."
    echo "2. Choose Administration Password in the Additional Settings dialog."
    echo "3. Specify a password of your choice in both the Administration Password and Confirm text boxes then click Add."
    echo "4. Now login to Tails as you normally do."
    echo "5. VERY IMPORTANT: Do not start the Tor Browser on startup. Connection to the Tor network with the assistant that is fine but DO NOT START TOR BROWSER YET. Complete all steps first."
    echo ""
    echo "Once Tails has loaded you have two options to bring up the root terminal which you need in order to run the script."
    echo "Option 1: Choose Applications > System Tools > Root Terminal."
    echo "Option 2: Execute in a terminal:   sudo -i"
    echo ""
    echo "In that session you need to navigate to where this script is stored. This script is currently running from:"
    echo $CURRENTDIR
    echo ""
    echo "You can do that by issueing in the root terminal:"
    echo "cd $CURRENTDIR"
    echo ""
    echo "Now you can finally run the script as you ran this script and you should not get this message. If you do get it read carefully and execute each step again."
    echo ""
    echo "--------------------------------------------------------"
    echo ""
    echo "Script exiting..."
    exit
fi


clear
echo "**********************************"
echo "*                                *"
echo "*    I2P on Tails script v0.1    *"
echo "*         September 2021         *"
echo "*                                *"
echo "*--------------------------------*"
echo "*    Experimental but working    *"
echo "*     on latest Tails version    *"
echo "*--------------------------------*"
echo "*                                *"
echo "*    Created by DeSnake          *"
echo "*           AlphaBay Marketplace *"
echo "*                                *"
echo "**********************************"
sleep 2


# We first install the service then stop it (in case it runs) afterwards to make our modifications

echo "[+] Downloading I2Pd ..."
cd /home/amnesia
sudo -u amnesia wget https://github.com/PurpleI2P/i2pd/releases/download/2.39.0/i2pd_2.39.0-1buster1_amd64.deb

echo "[+] Installing I2Pd ..."
#apt-get install i2pd -y
dpkg -i i2pd_2.39.0-1buster1_amd64.deb
apt-get update
apt-get -fy install
dpkg -i i2pd_2.39.0-1buster1_amd64.deb

echo "[+] Stopping I2Pd service ..."
systemctl stop i2pd


# Fixes i2pd.service file

echo "[+] Fixing i2pd.service file ..."

I2PDSERVICE=$(systemctl show -p FragmentPath i2pd.service | cut -d'=' -f 2)

echo '
[Unit]
Description=I2P Router written in C++
Documentation=man:i2pd(1) https://i2pd.readthedocs.io/en/latest/
After=network.target

[Service]
User=i2pd
Group=i2pd
RuntimeDirectory=i2pd
RuntimeDirectoryMode=0700
LogsDirectory=i2pd
LogsDirectoryMode=0700
Type=forking
ExecStart=/usr/sbin/i2pd --conf=/etc/i2pd/i2pd.conf --pidfile=/run/i2pd/i2pd.pid --logfile=/var/log/i2pd/i2pd.log --daemon --service
ExecReload=/bin/kill -HUP $MAINPID
PIDFile=/run/i2pd/i2pd.pid
### Uncomment, if auto restart needed
#Restart=on-failure

KillSignal=SIGQUIT
# If you have the patience waiting 10 min on restarting/stopping it, uncomment this.
# i2pd stops accepting new tunnels and waits ~10 min while old ones do not die.
#KillSignal=SIGINT
#TimeoutStopSec=10m

# If you have problems with hanging i2pd, you can try increase this
LimitNOFILE=4096
# To enable write of coredump uncomment this
#LimitCORE=infinity
PrivateDevices=yes

[Install]
WantedBy=multi-user.target
' > $I2PDSERVICE


# Improves speeds etc.

echo "[+] Improving I2P speeds etc ..."

echo "## Configuration file for a typical i2pd user
## See https://i2pd.readthedocs.io/en/latest/user-guide/configuration/
## for more options you can use in this file.

## Lines that begin with '## ' try to explain what's going on. Lines
## that begin with just '#' are disabled commands: you can enable them
## by removing the '#' symbol.

## Tunnels config file
## Default: ~/.i2pd/tunnels.conf or /var/lib/i2pd/tunnels.conf
# tunconf = /var/lib/i2pd/tunnels.conf

## Tunnels config files path
## Use that path to store separated tunnels in different config files.
## Default: ~/.i2pd/tunnels.d or /var/lib/i2pd/tunnels.d
# tunnelsdir = /var/lib/i2pd/tunnels.conf.d

## Where to write pidfile (don't write by default)
# pidfile = /var/run/i2pd.pid

## Logging configuration section
## By default logs go to stdout with level 'info' and higher
##
## Logs destination (valid values: stdout, file, syslog)
##  * stdout - print log entries to stdout
##  * file - log entries to a file
##  * syslog - use syslog, see man 3 syslog
# log = file
## Path to logfile (default - autodetect)
# logfile = /var/log/i2pd.log
## Log messages above this level (debug, *info, warn, error, none)
## If you set it to none, logging will be disabled
loglevel = debug
## Write full CLF-formatted date and time to log (default: write only time)
# logclftime = true

## Daemon mode. Router will go to background after start
# daemon = true

## Specify a family, router belongs to (default - none)
# family =

## External IP address to listen for connections
## By default i2pd sets IP automatically
# host = 1.2.3.4

## Port to listen for connections
## By default i2pd picks random port. You MUST pick a random number too,
## don't just uncomment this
# port = 4567

## Enable communication through ipv4
ipv4 = true
## Enable communication through ipv6
ipv6 = false

## Network interface to bind to
# ifname =
## You can specify different interfaces for IPv4 and IPv6
# ifname4 = 
# ifname6 = 

## Enable NTCP transport (default = true)
ntcp = true
## If you run i2pd behind a proxy server, you can only use NTCP transport with ntcpproxy option 
## Should be http://address:port or socks://address:port
# ntcpproxy = socks://localhost:9050
## Enable SSU transport (default = true)
ssu = true

## Should we assume we are behind NAT? (false only in MeshNet)
# nat = true

## Bandwidth configuration
## L limit bandwidth to 32KBs/sec, O - to 256KBs/sec, P - to 2048KBs/sec,
## X - unlimited
## Default is X for floodfill, L for regular node
bandwidth = P
## Max % of bandwidth limit for transit. 0-100. 100 by default
share = 100

## Router will not accept transit tunnels, disabling transit traffic completely
## (default = false)
# notransit = true

## Router will be floodfill
# floodfill = true

[http]
## Web Console settings
## Uncomment and set to 'false' to disable Web Console
# enabled = true
## Address and port service will listen on
address = 10.200.1.1
port = 7070
strictheaders = false
## Path to web console, default '/'
# webroot = /
## Uncomment following lines to enable Web Console authentication 
# auth = true
# user = i2pd
# pass = changeme

[httpproxy]
## Uncomment and set to 'false' to disable HTTP Proxy
# enabled = true
## Address and port service will listen on
address = 10.200.1.1
port = 4444
## Optional keys file for proxy local destination
# keys = http-proxy-keys.dat
## Enable address helper for adding .i2p domains with 'jump URLs' (default: true)
# addresshelper = true
## Address of a proxy server inside I2P, which is used to visit regular Internet
# outproxy = http://false.i2p
## httpproxy section also accepts I2CP parameters, like 'inbound.length' etc.

[socksproxy]
## Uncomment and set to 'false' to disable SOCKS Proxy
# enabled = true
## Address and port service will listen on
address = 10.200.1.1
port = 4447
## Optional keys file for proxy local destination
# keys = socks-proxy-keys.dat
## Socks outproxy. Example below is set to use Tor for all connections except i2p
## Uncomment and set to 'true' to enable using of SOCKS outproxy
# outproxy.enabled = false
## Address and port of outproxy
# outproxy = 127.0.0.1
# outproxyport = 9050
## socksproxy section also accepts I2CP parameters, like 'inbound.length' etc.

[sam]
## Uncomment and set to 'true' to enable SAM Bridge
enabled = false
## Address and port service will listen on
# address = 127.0.0.1
# port = 7656

[bob]
## Uncomment and set to 'true' to enable BOB command channel
enabled = false
## Address and port service will listen on
# address = 127.0.0.1
# port = 2827

[i2cp]
## Uncomment and set to 'true' to enable I2CP protocol
enabled = false
## Address and port service will listen on
# address = 127.0.0.1
# port = 7654

[i2pcontrol]
## Uncomment and set to 'true' to enable I2PControl protocol
enabled = false
## Address and port service will listen on
# address = 127.0.0.1
# port = 7650
## Authentication password. 'itoopie' by default
# password = itoopie

[precomputation]
## Enable or disable elgamal precomputation table
## By default, enabled on i386 hosts
# elgamal = true

[upnp]
## Enable or disable UPnP: automatic port forwarding (enabled by default in WINDOWS, ANDROID)
enabled = false
## Name i2pd appears in UPnP forwardings list (default = I2Pd)
# name = I2Pd

[reseed]
## Options for bootstrapping into I2P network, aka reseeding
## Enable or disable reseed data verification.
verify = true
## URLs to request reseed data from, separated by comma
## Default: 'mainline' I2P Network reseeds
# urls = https://reseed.i2p-projekt.de/,https://i2p.mooo.com/netDb/,https://netdb.i2p2.no/
## Path to local reseed data file (.su3) for manual reseeding
# file = /path/to/i2pseeds.su3
## or HTTPS URL to reseed from
# file = https://legit-website.com/i2pseeds.su3
## Path to local ZIP file or HTTPS URL to reseed from
# zipfile = /path/to/netDb.zip
## If you run i2pd behind a proxy server, set proxy server for reseeding here
## Should be http://address:port or socks://address:port
proxy = socks://localhost:9050
## Minimum number of known routers, below which i2pd triggers reseeding. 25 by default
# threshold = 25

[addressbook]
## AddressBook subscription URL for initial setup
## Default: inr.i2p at 'mainline' I2P Network
# defaulturl = http://joajgazyztfssty4w2on5oaqksz6tqoxbduy553y34mf4byv6gpq.b32.i2p/export/alive-hosts.txt
## Optional subscriptions URLs, separated by comma
# subscriptions = http://inr.i2p/export/alive-hosts.txt,http://stats.i2p/cgi-bin/newhosts.txt,http://rus.i2p/hosts.txt

[limits]
## Maximum active transit sessions (default:2500)
# transittunnels = 2500
## Limit number of open file descriptors (0 - use system limit)  
# openfiles = 0
## Maximum size of corefile in Kb (0 - use system limit) 
# coresize = 0
## Threshold to start probabalistic backoff with ntcp sessions (0 - use system limit) 
# ntcpsoft = 0
## Maximum number of ntcp sessions (0 - use system limit) 
# ntcphard = 0

[trust]
## Enable explicit trust options. false by default
# enabled = true
## Make direct I2P connections only to routers in specified Family.
# family = MyFamily
## Make direct I2P connections only to routers specified here. Comma separated list of base64 identities.
# routers = 
## Should we hide our router from other routers? false by default
# hidden = true

[exploratory]
## Exploratory tunnels settings with default values
# inbound.length = 2 
# inbound.quantity = 3
# outbound.length = 2
# outbound.quantity = 3

[persist]
## Save peer profiles on disk (default: true)
# profiles = true
" > /etc/i2pd/i2pd.conf

# Clear out log
rm -rf /var/log/i2pd/i2pd.log

# Clearing out default I2Pd tunnels for security reasons
echo "[+] Clearing out default I2Pd tunnels ..."
echo " " > /etc/i2pd/tunnels.conf

# Make a backup of tails-create-netns
cp /usr/local/lib/tails-create-netns /usr/local/lib/tails-create-netns_backup
/usr/local/lib/tails-create-netns stop

# Update netns with one which will work for I2Pd
mkdir /home/amnesia/.i2pd_script

cp $CURRENTDIR/tails-create-netns-i2p /home/amnesia/.i2pd_script/tails-create-netns-i2p

chmod +x /home/amnesia/.i2pd_script/tails-create-netns-i2p
sudo -u root /home/amnesia/.i2pd_script/tails-create-netns-i2p start

# IPtables rules to allow I2Pd software and corresponding ports
echo "[+] Setting firewall rules for I2P ..."
iptables -I INPUT 3 -p tcp -s 10.200.1.2 -d 10.200.1.1 -i veth-tbb -j ACCEPT -m multiport --destination-ports 4447,7070,8181
iptables -I OUTPUT 3 -p tcp -j ACCEPT -m tcp --tcp-flags SYN,ACK,FIN,RST SYN -m state --state NEW -m owner --uid-owner i2pd
sleep 1

# Start i2pd
echo "[+] Starting I2Pd service ..."
systemctl start i2pd

# Create directory which will host our proxy script to redirect .i2p
sudo -u amnesia mkdir /home/amnesia/Tor\ Browser/localhost-tbb-proxy-pac

sudo -u amnesia echo '
function FindProxyForURL(url, host)
{
  if ( shExpMatch(host, "*.i2p$") ) {
    return "SOCKS 127.0.0.1:4447"
  }
  return "SOCKS 127.0.0.1:9050";
}

' > /home/amnesia/Tor\ Browser/localhost-tbb-proxy-pac/proxy.pac

chmod +x /home/amnesia/Tor\ Browser/localhost-tbb-proxy-pac/proxy.pac
chown amnesia:amnesia /home/amnesia/Tor\ Browser/localhost-tbb-proxy-pac/proxy.pac

# Start simple local python server to serve the proxy pac file
echo "[+] Starting local server to handle .i2p proxifying ..."

sudo -u amnesia python3 -m http.server --bind 10.200.1.1 --directory /home/amnesia/Tor\ Browser/localhost-tbb-proxy-pac 8181 >/dev/null 2>&1 &


echo "[+] Making a backup of your Tor Browser preferences just in case ..."

cp /home/amnesia/.tor-browser/profile.default/prefs.js /home/amnesia/.tor-browser/profile.default/i2p_enabled_backup_prefs.js

echo "[+] Configuring Tor Browser for I2P usage ..."


# Enable I2P on browser

if grep 'extensions.torbutton.use_nontor_proxy' /home/amnesia/.tor-browser/profile.default/prefs.js
then
    sed -i -e 's/^user_pref("extensions.torbutton.use_nontor_proxy", \(true\|false\));$/user_pref("extensions.torbutton.use_nontor_proxy", true);/' /home/amnesia/.tor-browser/profile.default/prefs.js
else
    echo 'user_pref("extensions.torbutton.use_nontor_proxy", true);' >> /home/amnesia/.tor-browser/profile.default/prefs.js
fi


if grep 'network.proxy.allow_hijacking_localhost' /home/amnesia/.tor-browser/profile.default/prefs.js
then
    sed -i -e 's/^user_pref("network.proxy.allow_hijacking_localhost", \(true\|false\));$/user_pref("network.proxy.allow_hijacking_localhost", false);/' /home/amnesia/.tor-browser/profile.default/prefs.js
else
    echo 'user_pref("network.proxy.allow_hijacking_localhost", false);' >> /home/amnesia/.tor-browser/profile.default/prefs.js
fi

if grep 'network.proxy.socks' /home/amnesia/.tor-browser/profile.default/prefs.js
then
    sed -i -e 's/^user_pref("network.proxy.socks", \(true\|false\));$/user_pref("network.proxy.socks", "");/' /home/amnesia/.tor-browser/profile.default/prefs.js
else
    echo 'user_pref("network.proxy.socks", "");' >> /home/amnesia/.tor-browser/profile.default/prefs.js
fi

if grep 'network.proxy.autoconfig_url' /home/amnesia/.tor-browser/profile.default/prefs.js
then
    sed -i -e 's/^user_pref("network.proxy.autoconfig_url", \(true\|false\));$/user_pref("network.proxy.autoconfig_url", "http://127.0.0.1:8181/proxy.pac");/' /home/amnesia/.tor-browser/profile.default/prefs.js
else
    echo 'user_pref("network.proxy.autoconfig_url", "http://127.0.0.1:8181/proxy.pac");' >> /home/amnesia/.tor-browser/profile.default/prefs.js
fi

if grep 'network.proxy.type' /home/amnesia/.tor-browser/profile.default/prefs.js
then
    sed -i -e 's/^user_pref("network.proxy.type", \(2\|1\));$/user_pref("network.proxy.type", 2);/' /home/amnesia/.tor-browser/profile.default/prefs.js
else
    echo 'user_pref("network.proxy.type", 2);' >> /home/amnesia/.tor-browser/profile.default/prefs.js
fi


# Set desktop icons

echo "[+] Setting desktop icons ..."

cp $CURRENTDIR/enable_i2p.sh /home/amnesia/.i2pd_script/enable_i2p.sh
cp $CURRENTDIR/disable_i2p.sh /home/amnesia/.i2pd_script/disable_i2p.sh

chmod +x /home/amnesia/.i2pd_script/enable_i2p.sh
chmod +x /home/amnesia/.i2pd_script/disable_i2p.sh

echo "
[Desktop Entry]
Type=Application
Exec=/home/amnesia/.i2pd_script/enable_i2p.sh
Name=Enable I2P
GenericName=I2P
StartupNotify=true
Categories=Network;
" >> /home/amnesia/Desktop/enable_i2p.desktop

echo "
[Desktop Entry]
Type=Application
Exec=/home/amnesia/.i2pd_script/disable_i2p.sh
Name=Disable I2P
GenericName=I2P
StartupNotify=true
Categories=Network;
" >> /home/amnesia/Desktop/disable_i2p.desktop


chmod +x /home/amnesia/Desktop/enable_i2p.desktop
chmod +x /home/amnesia/Desktop/disable_i2p.desktop


echo ""
echo ""


echo "IMPORTANT: You MUST wait 2-5 minutes depending on your network in order for I2P to connect properly. Also do note that you must put HTTP:// infront of I2P websites in order for them to work. I2P is end-to-end encrypted so it does not matter if it says HTTP and not HTTPS."
echo "After you have waited you now start Tor Browser and see if you can reach the I2Pd router console:"
echo ""
echo "http://127.0.0.1:7070"
echo ""
echo "If you are able to reach either of those you are able to reach e.g. marketplaces under I2P (like AlphaBay) or any other I2P service."
echo ""
echo "There are 2 icons on the Desktop to start and stop I2P. Right click them and make it executable. You can now browse both .i2p and .onion sites."
echo ""
echo ""
echo "###############################"
echo ""
echo "Complete the following tasks:"
echo ""
echo "1. Check the about:config setting 'network.proxy.type' after every Tor Browser restart. It MUST be set to 2"
echo "2. Check the about:config setting 'network.proxy.socks' after every Tor Browser restart. It MUST empty"
echo "3. Remember book is not added so http://stats.i2p or http://zzz.i2p will NOT map for you. You MUST get .b32.i2p addresses and then load them."
echo ""
echo "###############################"
echo ""
echo ""
echo "[+] All done. Exiting ..."

notify-send "I2P enabled"
notify-send 'Check the about:config setting "network.proxy.type" after every Tor Browser restart. It MUST be set to 2'
notify-send "Check the about:config setting 'network.proxy.socks' after every Tor Browser restart. It MUST empty"

# Credits to the following resources and people which I used/worked with to make this happen:
# Konrad Bächler, Tails devs, I2P devs, I2Pd devs, Tails documentation, I2Pd documentation, Tor documentation, Tails Gitlab repo
