#!/bin/bash
# install.sh
# Installs smartnode on Ubuntu 17.10 x64
# ATTENTION: The anti-ddos part will disable http, https and dns ports.

# Warning that the script will reboot the server
echo "WARNING: This script will reboot the server when it's finished."
printf "Press Ctrl+C to cancel or Enter to continue: "
read IGNORE

cd
# Changing the SSH Port to a custom number is a good security measure against DDOS attacks
printf "Custom SSH Port(Enter to ignore): "
read VARIABLE
_sshPortNumber=${VARIABLE:-22}

# Get a new privatekey by going to console >> debug and typing smartnode genkey
printf "SmartNode GenKey: "
read _nodePrivateKey

# The RPC node will only accept connections from your localhost
_rpcUserName=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12 ; echo '')

# Choose a random and secure password for the RPC
_rpcPassword=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')

# Get the IP address of your vps which will be hosting the smartnode
_nodeIpAddress=$(hostname  -I | cut -f1 -d' ')

# Make a new directory for smartcash daemon
rm -r ~/.smartcash/
mkdir ~/.smartcash/
touch ~/.smartcash/smartcash.conf

# Change the directory to ~/.smartcash
cd ~/.smartcash/

# Create the initial smartcash.conf file
echo "rpcuser=${_rpcUserName}
rpcpassword=${_rpcPassword}
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
logtimestamps=1
maxconnections=64
txindex=1
smartnode=1
externalip=${_nodeIpAddress}:9678
smartnodeprivkey=${_nodePrivateKey}
" > smartcash.conf
cd

# Install smartcashd using apt-get
add-apt-repository ppa:smartcash/ppa -y
apt-get update
apt-get install smartcashd -y
smartcashd

# Create a directory for smartnode's cronjobs and the anti-ddos script
rm -r smartnode
mkdir smartnode

# Change the directory to ~/smartnode/
cd ~/smartnode/

# Download the appropriate scripts
wget https://raw.githubusercontent.com/SmartCash/smartnode/master/anti-ddos.sh
wget https://raw.githubusercontent.com/SmartCash/smartnode/master/makerun.sh
wget https://raw.githubusercontent.com/SmartCash/smartnode/master/checkdaemon.sh
wget https://raw.githubusercontent.com/SmartCash/smartnode/master/upgrade.sh

# Create a cronjob for making sure smartcashd is always running
(crontab -l ; echo "*/1 * * * * ~/smartnode/makerun.sh") | crontab -
chmod 0700 ./makerun.sh

# Create a cronjob for making sure the daemon is never stuck
(crontab -l ; echo "*/30 * * * * ~/smartnode/checkdaemon.sh") | crontab -
chmod 0700 ./checkdaemon.sh

# Create a cronjob for making sure smartcashd is always up-to-date
(crontab -l ; echo "*/120 * * * * ~/smartnode/upgrade.sh") | crontab -
chmod 0700 ./upgrade.sh

# Change the SSH port
sed -i "s/#Port 22/Port ${_sshPortNumber}/g" /etc/ssh/sshd_config
sed -i "s/14855/${_sshPortNumber}/g" ~/smartnode/anti-ddos.sh

# Run the anti-ddos script
bash ./anti-ddos.sh

# Reboot the server
reboot
