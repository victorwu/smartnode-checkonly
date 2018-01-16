# SmartNode
### Bash installer for smartnode on Ubuntu 17.10 x64
### ATTENTION: This installer is only suitable for dedicated servers. The anti-ddos script in this installer will disable all ports including the http, https and dns ports.

#### Login to your vps, donwload the install.sh file and then run it:
```
wget https://raw.githubusercontent.com/msg768/smartnode/master/install.sh
bash ./install.sh
```

#### On the client-side, add the following line to smartnode.conf:
```
node-alias vps-ip-address:9678	node-privatekey collateral-txid collateral-vout
```

#### BEE $SMART!
