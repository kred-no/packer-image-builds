#!/usr/bin/env bash
set +x -eu -o pipefail

log() {
  printf "[%s] %s\n" "$(date)" "${1}"
}

ANSIBLE_USER="ansible"
PIP_ROOT_USER_ACTION="ignore" # or use --root-user-action=ignore

log "Installing OS packages"
echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections
apt-get -y   -o DPkg::Lock::Timeout=30 update
apt-get -qqy -o DPkg::Lock::Timeout=30 install apt-utils
apt-get -qqy -o DPkg::Lock::Timeout=30 install openssh-client
apt-get -qqy -o DPkg::Lock::Timeout=30 install python3-pip

log "Installing PIP modules"
python3 -m pip install --upgrade pip --no-cache-dir
python3 -m pip install --upgrade wheel --no-cache-dir
python3 -m pip install --upgrade paramiko ansible-core --no-cache-dir

log "Installing Ansible collections"
echo "export ANSIBLE_COLLECTIONS_PATH=/usr/share/ansible/collections"|tee -a /etc/environment
. /etc/environment
ansible-galaxy collection install community.general
ansible-galaxy collection install community.azure
ansible-galaxy collection install community.vmware

log "Creating Ansible user"
useradd --comment "Ansible User" --system --shell /bin/false --create-home ${ANSIBLE_USER}
echo "${ANSIBLE_USER} ALL=(ALL) NOPASSWD: ALL"|tee -a /etc/sudoers.d/${ANSIBLE_USER}
chmod 0440 /etc/sudoers.d/${ANSIBLE_USER}

exit 0