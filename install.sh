#!/bin/bash
# install.sh
# Installs smartnode on Ubuntu 17.10 x64
# ATTENTION: The anti-ddos part will disable http, https and dns ports.

cd
# Changing the SSH Port to a custom number is a good security measure against DDOS attacks
printf "Custom SSH Port(Enter to ignore): "
read VARIABLE
_sshPortNumber=${VARIABLE:-22}

# The RPC node will only accept connections from your localhost
printf "RPC UserName: "
read _rpcUserName

# Choose a random and secure password for the RPC
printf "RPC Password: "
read _rpcPassword

# The IP address of your vps which will be hosting the smartnode
printf "VPS IP Address: "
read _nodeIpAddress

# Get a new privatekey by going to console >> debug and typing smartnode genkey
printf "SmartNode PrivateKey: "
read _nodePrivateKey

# Make a new directory for smartcash daemon
rm -r ~/smartcash/
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
wget https://raw.githubusercontent.com/msg768/smartnode/master/anti-ddos.sh
wget https://raw.githubusercontent.com/msg768/smartnode/master/makerun.sh
wget https://raw.githubusercontent.com/msg768/smartnode/master/upgrade.sh

# Create a cronjob for making sure smartcashd is always running
(crontab -l ; echo "*/1 * * * * ~/smartnode/makerun.sh") | crontab -
chmod 0700 ./makerun.sh

# Create a cronjob for making sure smartcashd is always up-to-date
(crontab -l ; echo "*/1440 * * * * ~/smartnode/upgrade.sh") | crontab -
chmod 0700 ./upgrade.sh

# Change the SSH port
sed -i "s/#Port 22/Port ${_sshPortNumber}/g" /etc/ssh/sshd_config
sed -i "s/14855/${_sshPortNumber}/g" ~/smartnode/anti-ddos.sh

# Run the anti-ddos script
bash ./anti-ddos.sh

# Reboot the server
reboot
