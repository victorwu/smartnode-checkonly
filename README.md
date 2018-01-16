# SmartNode
### Bash installer for smartnode on Ubuntu 17.10 x64
### ATTENTION: This installer is only suitable for a dedicated vps. The anti-ddos script in this installer will disable all ports including the http, https and dns ports. It will only leave the smartnode port open as well as a custom port for SSH.

#### Login to your vps, donwload the install.sh file and then run it:
```
wget https://raw.githubusercontent.com/msg768/smartnode/master/install.sh
bash ./install.sh
```

#### On the client-side, add the following line to smartnode.conf:
```
node-alias vps-ip-address:9678	node-privatekey collateral-txid collateral-vout
```

#### Run the qt wallet, go to SmartNodes tab, choose your node and click "start alias" at the bottom.

#### You're good to go now. BEE $SMART!
