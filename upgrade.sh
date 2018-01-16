#!/bin/bash
# upgrade.sh
# Make sure smartcash is up-to-date
# Add the following to the crontab (i.e. crontab -e)
# */120 * * * * ~/smartnode/upgrade.sh

if apt list --upgradable | grep -v grep | grep smartcash > /dev/null
then
  smartcash-cli stop && sleep 20 && apt update && apt install smartcashd -y && sleep 20 && smartcashd
else
  exit
fi
