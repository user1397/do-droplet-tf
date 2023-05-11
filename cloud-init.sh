#!/bin/bash

SUDO_USER=yoloadmin
SSH_PORT=55022

useradd -m $SUDO_USER -s /bin/bash
echo "${SUDO_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$SUDO_USER
chmod 440 /etc/sudoers.d/$SUDO_USER
mkdir -p /home/$SUDO_USER/.ssh
mv /root/.ssh/authorized_keys /home/$SUDO_USER/.ssh/
chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.ssh

sed -i "s/#Port 22/Port ${SSH_PORT}/g" /etc/ssh/sshd_config
sed -i "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
sed -i "s/PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
sed -i "s/X11Forwarding yes/X11Forwarding no/g" /etc/ssh/sshd_config
systemctl restart sshd

apt update
apt full-upgrade -y
apt install zip unzip -y
