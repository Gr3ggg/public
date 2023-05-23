#!/bin/sh

# manuellement
sudo find /$PATH -name ".DS_Store" -depth -exec rm {} \;

##############################################

# auto

sudo crontab -e

15 19 * * * root find /$PATH -name ".DS_Store" -depth -exec rm {} \;
