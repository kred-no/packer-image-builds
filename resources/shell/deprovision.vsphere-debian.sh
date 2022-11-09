#!/usr/bin/env sh
set -x

sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg
truncate -s0 /etc/hostname
hostnamectl set-hostname localhost
rm /etc/netplan/50-cloud-init.yaml
cat /dev/null > ~/.bash_history && history -c

export HISTSIZE=0
sync

shutdown now