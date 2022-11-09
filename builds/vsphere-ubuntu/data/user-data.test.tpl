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
  user-data:
    timezone: Europe/Oslo
    disable_root: no
    package_update: yes
    package_upgrade: no
    users:
    - default
    - name: ${ username }
        gecos: System Administrator
        sudo: ALL=(ALL) NOPASSWD:ALL
        groups: users, admin
        lock_passwd: yes
        plain_text_passwd: ${ password }
        %{~ if  length(ssh_keys) > 0 ~}
        ssh_authorized_keys:
        %{~ for key in ssh_keys ~}
        - ${ key }
        %{~ endfor ~}
        %{~ endif ~}
    power_state:
      delay: 5
      mode: reboot
  late-commands: # OS mounted in /target
  - "sed -i -e \"2s/^.*/datasource_list: [ VMware,None ]/g\" /target/etc/cloud/cloud.cfg.d/90_dpkg.cfg"
  - sed -i -e 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /target/etc/ssh/sshd_config
  - curtin in-target --target=/target -- dpkg-reconfigure -f noninteractive cloud-init
  - curtin in-target --target=/target -- systemctl stop systemd-networkd-wait-online
