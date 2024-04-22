#!/usr/bin/env bash
set -x

# make sure we cannot directly login as root.
sudo usermod --lock root

# Let the sudo group members use root permissions without a password.
#sed -i -E 's,^%sudo\s+.+,%sudo ALL=(ALL) NOPASSWD:ALL,g' /etc/sudoers

# Install the vagrant public key.
# > Vagrant will replace it on the first run.
install -d -m 700 /home/vagrant/.ssh
pushd /home/vagrant/.ssh
wget -qOauthorized_keys https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub
chmod 600 authorized_keys
chown -R vagrant:vagrant .
popd

# Install cloud-init.
#apt-get install -qqy --no-install-recommends cloud-init cloud-initramfs-growroot

# Disable the DNS reverse lookup on the SSH server. this stops it from
# trying to resolve the client IP address into a DNS domain name, which
# is kinda slow and does not normally work when running inside VB.
echo UseDNS no | sudo tee -a /etc/ssh/sshd_config

# Reset the machine-id.
# > systemd will re-generate it on the next boot.
# > machine-id is indirectly used in DHCP as Option 61 (Client Identifier), which
#   the DHCP server uses to (re-)assign the same or new client IP address.
echo '' | sudo tee /etc/machine-id
sudo rm -f /var/lib/dbus/machine-id

# Reset the random-seed.
# > systemd-random-seed re-generates it on every boot and shutdown.
sudo systemctl stop systemd-random-seed
sudo rm -f /var/lib/systemd/random-seed

# Cleanup packages.
sudo apt-get -qqy autoremove --purge
sudo apt-get -qqy clean
