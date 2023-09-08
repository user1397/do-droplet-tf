#!/usr/bin/env bash

# Update system
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get purge apt-listchanges -y
apt-get autoremove -y
apt-get dist-upgrade -yq
apt-get autoremove -y
apt-get clean

# Install packages
apt-get install git docker.io -y
apt-get update

# Set vars
# If you change the ssh port here, you'll
# also have to change it in variables.tf
SUDO_USER=yoloadmin
SSH_PORT=55022

# Create sudo user
useradd -m $SUDO_USER -s /bin/bash
echo "${SUDO_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$SUDO_USER
chmod 440 /etc/sudoers.d/$SUDO_USER

# Setup ssh key access for sudo user
mkdir -p /home/$SUDO_USER/.ssh
mv /root/.ssh/authorized_keys /home/$SUDO_USER/.ssh/
chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.ssh

# Secure sshd config and restart sshd
sed -i "s/#Port 22/Port ${SSH_PORT}/g" /etc/ssh/sshd_config
sed -i "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
sed -i "s/PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
sed -i "s/X11Forwarding yes/X11Forwarding no/g" /etc/ssh/sshd_config
systemctl restart sshd
