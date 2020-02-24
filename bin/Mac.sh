#!/bin/bash
sudo ifconfig en0 ether b8:33:7f:2b:7d:94
open $HOME/Applications/reboot\ wifi.app
# osascript -e 'quit app "Terminal"'