#!/bin/sh

sudo find /PATH -name ".DS_Store" -depth -exec rm {} \;

##############################################

sudo crontab -e

15 1 * * * root find /PATH -name ".DS_Store" -depth -exec rm {} \;
