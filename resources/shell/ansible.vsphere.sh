#!/usr/bin/env bash
set -x
printf "[%s] User '%s' is installing Ansible\n" "$(date)" "${USER}"

echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections
apt-get -y   -o DPkg::Lock::Timeout=30 update
apt-get -qqy -o DPkg::Lock::Timeout=30 install apt-utils
apt-get -qqy -o DPkg::Lock::Timeout=30 install openssh-client --no-install-recommends
apt-get -qqy -o DPkg::Lock::Timeout=30 install python3-pip --no-install-recommends

export PIP_ROOT_USER_ACTION=ignore # or use --root-user-action=ignore
python3 -m pip install --upgrade pip --no-cache-dir
python3 -m pip install --upgrade wheel --no-cache-dir
python3 -m pip install --upgrade paramiko ansible-core --no-cache-dir

echo "export ANSIBLE_COLLECTIONS_PATH=/usr/share/ansible/collections"|tee -a /etc/environment
. /etc/environment
ansible-galaxy collection install community.general

export ANSIBLE_USER=ansible
useradd --comment "Ansible User" --system --shell /bin/false --create-home ${ANSIBLE_USER}
echo "${ANSIBLE_USER} ALL=(ALL) NOPASSWD: ALL"|tee -a /etc/sudoers.d/${ANSIBLE_USER}
chmod 0440 /etc/sudoers.d/${ANSIBLE_USER}
