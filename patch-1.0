# Change the directory to ~/smartnode
cd ~/smartnode

# Download the new crontjob
wget https://raw.githubusercontent.com/SmartCash/smartnode/master/clearlog.sh 

# Create a cronjob for clearing the log file
(crontab -l ; echo "0 0 */2 * * ~/smartnode/clearlog.sh") | crontab -
chmod 0700 ./clearlog.sh

./clearlog.sh
