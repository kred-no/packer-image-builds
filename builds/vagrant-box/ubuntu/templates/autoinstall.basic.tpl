#cloud-config
autoinstall:
  version: 1

  refresh-installer:
    update: yes
    #channel: edge

  # Stopping ssh-server during initial setup (packer)
  early-commands:
  - systemctl stop ssh

  identity:
    username: ${username}
    password: '${password}'
    hostname: ubuntu

  timezone: Europe/Oslo
  
  locale: nb_NO.UTF8
  
  keyboard:
    layout: 'no'

  ssh:
    install-server: yes
    authorized-keys: []

  storage:
    layout:
      name: direct

  # Required by Hyper-V for detecting IP-changes during packer builds
  packages:
  - linux-virtual
  - linux-tools-virtual
  - linux-cloud-tools-virtual

  # NOTE: curtin in-target runs as 'root' user
  late-commands:
  - echo '${username} ALL=(ALL) NOPASSWD:ALL' > /target/etc/sudoers.d/${username}
  - curtin in-target --target=/target -- systemctl enable ssh
