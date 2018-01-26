#!/bin/bash
# install.sh
# Checks smartnode on Ubuntu 17.10 x64
# ATTENTION: The anti-ddos part will disable http, https and dns ports.

if [ "$(whoami)" == "root" ]; then
  echo "Script must be run as user: smartadmin or ID you setup for smartcash"
  exit -1
fi

# Warning that the script will reboot the server
echo "WARNING: This script will reboot the server when it's finished."
printf "Press Ctrl+C to cancel or Enter to continue: "
read IGNORE

cd
# Changing the SSH Port to a custom number is a good security measure against DDOS attacks
# printf "Custom SSH Port(Enter to ignore): "
# read VARIABLE
# _sshPortNumber=${VARIABLE:-22}

# Create a directory for smartnode's cronjobs and the anti-ddos script
rm -r smartnode
mkdir smartnode

# Change the directory to ~/smartnode/
cd ~/smartnode/

# Download the appropriate scripts
wget https://github.com/controllinghand/smartnode-checkonly/master/anti-ddos.sh
wget https://github.com/controllinghand/smartnode-checkonly/master/makerun.sh
wget https://github.com/controllinghand/smartnode-checkonly/master/checkdaemon.sh
wget https://github.com/controllinghand/smartnode-checkonly/master/upgrade.sh
wget https://github.com/controllinghand/smartnode-checkonly/master/clearlog.sh

# Create a cronjob for making sure smartcashd is always running
(crontab -l ; echo "*/1 * * * * ~/smartnode/makerun.sh") | crontab -
chmod 0700 ./makerun.sh

# Create a cronjob for making sure the daemon is never stuck
(crontab -l ; echo "*/30 * * * * ~/smartnode/checkdaemon.sh") | crontab -
chmod 0700 ./checkdaemon.sh

# Create a cronjob for making sure smartcashd is always up-to-date
(crontab -l ; echo "*/120 * * * * ~/smartnode/upgrade.sh") | crontab -
chmod 0700 ./upgrade.sh

# Create a cronjob for clearing the log file
(crontab -l ; echo "0 0 */2 * * ~/smartnode/clearlog.sh") | crontab -
chmod 0700 ./clearlog.sh

# Change the SSH port
# sed -i "s/[#]\{0,1\}[ ]\{0,1\}Port [0-9]\{2,\}/Port ${_sshPortNumber}/g" /etc/ssh/sshd_config
# sed -i "s/14855/${_sshPortNumber}/g" ~/smartnode/anti-ddos.sh

# Run the anti-ddos script You will need to put in your sudo password
sudo bash ./anti-ddos.sh

# Reboot the server
sudo reboot
