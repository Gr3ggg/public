#!/bin/sh 

# en root

apt update && apt upgrade -y && apt autoremove -y

apt install -y htop sudo rsync nload git screen tree unzip vim zsh curl gnupg2 qemu-guest-agent cloud-init

############################################

sed -i -E "s/^#?PermitRootLogin\s+.*/PermitRootLogin yes/" "/etc/ssh/sshd_config"

############################################
mv /etc/network/interfaces /etc/network/interfacesold
sed -n '1,4p' /etc/network/interfacesold > /etc/network/interfaces

############################################
# disable_root: false
mv /etc/cloud/cloud.cfg /etc/cloud/cloudold.cfg
sed -i "s/disable_root: true/disable_root: false/g" "/etc/cloud/cloudold.cfg"
sed -n '1,/distro: debian/p; /# Other config here will be given to the distro class and\/or path classes/,$p' "/etc/cloud/cloudold.cfg" > "/etc/cloud/cloud.cfg"

############################################

# verifier si on peut ssh directement avec ROOT et ensuite :

deluser --remove-home user

############################################

sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/' /etc/default/grub
update-grub

poweroff