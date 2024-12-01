#!/bin/sh 

# en root

apt update && apt upgrade -y && apt autoremove -y

apt install -y htop sudo rsync nload git screen tree unzip vim zsh curl gnupg2 qemu-guest-agent cloud-init


############################################
mv /etc/network/interfaces /etc/network/interfacesold
sed -n '1,4p' /etc/network/interfacesold > /etc/network/interfaces

############################################

# verifier si on peut ssh directement avec ROOT et ensuite :

deluser --remove-home user

############################################

sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/' /etc/default/grub
update-grub

poweroff