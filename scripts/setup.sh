#!/usr/bin/env bash
set -x

function waiting_some_seconds() {
  if [[ ! -z "$1" ]]
  then
    SEC=$1
  else
    SEC=30
  fi
  echo "Waiting $SEC sec"
  sleep $SEC
}


waiting_some_seconds 60

# Install necessary dependencies
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
sudo apt-get -y -qq install curl wget git vim apt-transport-https ca-certificates

# PHASE-2
waiting_some_seconds 60
sudo rm -rf /var/lib/dpkg/updates/*
sudo dpkg --configure -a
sudo add-apt-repository -r universe
sudo apt update
waiting_some_seconds 60
sudo add-apt-repository universe
sudo apt update
sudo apt -y -qq install qemu-guest-agent net-tools

FILE="/lib/udev/rules.d/80-hotplug-cpu.rules"

if [[ -f "$FILE" ]]; then
  echo "$FILE exists."
else
  echo 'SUBSYSTEM=="cpu", ACTION=="add", TEST=="online", ATTR{online}=="0", ATTR{online}="1"' | sudo tee ${FILE}
fi

sudo apt upgrade -y

sudo apt -y -qq install net-tools openssh-server

# Regenerate SSH host keys
sudo /bin/rm -f -v /etc/ssh/ssh_host_*
sudo dpkg-reconfigure openssh-server
sudo systemctl restart sshd.service

# Setup sudo to allow no-password sudo for "admins" group and adding "automator" user
sudo groupadd -r admins
sudo usermod -a -G admins automator
sudo cp /etc/sudoers /etc/sudoers.orig
echo "admins ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/admins

# Installing SSH key
sudo mkdir -p /home/automator/.ssh
sudo chmod 700 /home/automator/.ssh
curl http://10.20.213.200/authorized_keys -o /tmp/admins-keys.pub
sudo cp /tmp/admins-keys.pub /home/automator/.ssh/authorized_keys
sudo chmod 600 /home/automator/.ssh/authorized_keys
sudo chown -R automator /home/automator/.ssh
sudo usermod --shell /bin/bash automator

# Reboot
# sudo reboot
