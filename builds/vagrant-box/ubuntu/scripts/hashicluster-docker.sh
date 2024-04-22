#!/usr/bin/env bash
set -ex

NOMAD_CONDITION=">=1.7.7-1"
CONSUL_CONDITION=">=1.18.1-1"
VAULT_CONDITION=">=1.16.1-1"
TERRAFORM_CONDITION=">=1.8.1-1"

CNI_PLUGIN_VERSION="1.0.0"

# Install required OS packages
sudo apt-get update
sudo apt-get -qqy install gpg ca-certificates coreutils curl wget unzip

# Install Docker
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  sudo apt-get -qqy remove $pkg;
done

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get -qqy install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER

# Install HashiCorp applications
RELEASE=$(lsb_release -cs)
if [ "$RELEASE" == "noble" ]; then
  echo "Release not yet supported; falling back to previous release. See 'https://www.hashicorp.com/official-packaging-guide' for supported versions"
  RELEASE="mantic"
fi

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $RELEASE main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt-get update
sudo apt-get -qqy satisfy "nomad ($NOMAD_CONDITION)"
sudo apt-get -qqy satisfy "consul ($CONSUL_CONDITION)"
sudo apt-get -qqy satisfy "vault ($VAULT_CONDITION)"
sudo apt-get -qqy satisfy "terraform ($TERRAFORM_CONDITION)"

# Download & configure CNI Plugins
# See https://developer.hashicorp.com/nomad/docs/install
curl -L -o cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGIN_VERSION}/cni-plugins-linux-$( [ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)"-v${CNI_PLUGIN_VERSION}.tgz
sudo mkdir -p /opt/cni/bin
sudo tar -C /opt/cni/bin -xzf cni-plugins.tgz

sudo modprobe br_netfilter
sudo sysctl -p /etc/sysctl.conf

echo 1 | sudo tee /proc/sys/net/bridge/bridge-nf-call-arptables
echo 1 | sudo tee /proc/sys/net/bridge/bridge-nf-call-ip6tables
echo 1 | sudo tee /proc/sys/net/bridge/bridge-nf-call-iptables

sudo touch /etc/sysctl.d/bridge.conf
echo "net.bridge.bridge-nf-call-arptables = 1" | sudo tee -a /etc/sysctl.d/bridge.conf
echo "net.bridge.bridge-nf-call-ip6tables = 1" | sudo tee -a /etc/sysctl.d/bridge.conf
echo "net.bridge.bridge-nf-call-iptables = 1"  | sudo tee -a /etc/sysctl.d/bridge.conf

# Manage services
# /lib/systemd/system/consul.service should fixed. Check for folder instead of file
sudo systemctl daemon-reload
sudo systemctl disable nomad.service
sudo systemctl disable consul.service
sudo systemctl disable vault.service

# Cleanup
rm -f cni-plugins.tgz

exit 0
