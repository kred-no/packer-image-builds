#cloud-config
autoinstall:
  version: 1
  early-commands:
  - systemctl stop ssh # Prevent Packer connecting untill rebooted
  locale: nb_NO
  keyboard:
    layout: 'no'
  refresh-installer:
    update: yes
    channel: stable
  apt:
    geoip: yes
    preserve_sources_list: no
    primary:
    - arches: [amd64, i386]
      uri: http://no.archive.ubuntu.com/ubuntu
    - arches: [default]
      uri: http://ports.ubuntu.com/ubuntu-ports
  packages:
  - open-vm-tools
  storage: # https://curtin.readthedocs.io/en/latest/topics/storage.html
    layout:
      name: direct
  network:
    network:
      version: 2
      renderer: networkd
      ethernets:
        nics:
          match:
            name: ens*
          dhcp4: no
          dhcp6: no
          addresses:
          - ${ address }
          routes:
          - to: default
            via: ${ gateway }
          nameservers:
            addresses:
            %{~ for addr in nameservers ~}
            - ${ addr }
            %{~ endfor ~}
  identity:
    hostname: ${ hostname }
    username: ${ username }
    password: ${ password }
  ssh:
    install-server: yes
    allow-pw: yes
    %{~ if  length(ssh_keys) > 0 ~}
    authorized-keys:
    %{~ for key in ssh_keys ~}
    - ${ key }
    %{~ endfor ~}
    %{~ endif ~}
  user-data:
    timezone: Europe/Oslo
    disable_root: no
    package_update: yes
    package_upgrade: no
    power_state:
      delay: 5
      mode: reboot
  late-commands: # OS mounted in /target
  - sed -i -e 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /target/etc/ssh/sshd_config
  - "sed -i -e \"2s/^.*/datasource_list: [ VMware,None ]/g\" /target/etc/cloud/cloud.cfg.d/90_dpkg.cfg"
  - echo '${ username } ALL=(ALL) NOPASSWD:ALL' | tee /target/etc/sudoers.d/${ username }
  - curtin in-target --target=/target -- dpkg-reconfigure -f noninteractive cloud-init
  - curtin in-target --target=/target -- chmod 440 /etc/sudoers.d/${ username }
  - curtin in-target --target=/target -- systemctl stop systemd-networkd-wait-online
