#!/usr/bin/env sh
set -x

# cleanup cloud-init
rm -rf /var/lib/cloud/*
rm -rf /var/log/cloud-init*
rm -rf /tmp/cloud-init
ln -s /var/lib/cloud/instances /var/lib/cloud/instance

# deprovision
/usr/sbin/waagent -force -deprovision+user
export HISTSIZE=0
sync
