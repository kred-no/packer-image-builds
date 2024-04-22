#_preseed_V1
# Fully automated installation script:
#
# linux vmlinuz initrd=initrd.gz \
#   auto-install/enable=true \
#   debconf/priority=critical \
#   preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg

# Installer
d-i    debian-installer/country                        string         US
d-i    debian-installer/language                       string         en
d-i    debian-installer/locale                         select         en_US.UTF-8

# Locale & Language
d-i    localechooser/supported-locales                 multiselect    en_US.UTF-8, nb_NO.UTF-8
d-i    localechooser/preferred-locale                  select         nb_NO.UTF-8

# Keyboard
d-i     keyboard-configuration/xkb-keymap              select         no
d-i     keyboard-configuration/layoutcode              string         no
d-i     keyboard-configuration/modelcode               string         pc105
d-i     keyboard-configuration/toggle                  select         No toggling

# Time & Timezone
d-i    clock-setup/utc                                 boolean        true
d-i    clock-setup/ntp                                 boolean        true
d-i    clock-setup/ntp-server                          string         0.no.pool.ntp.org 1.no.pool.ntp.org 2.no.pool.ntp.org 3.no.pool.ntp.org
d-i    time/zone                                       string         Europe/Oslo

# Network
d-i    netcfg/choose_interface                         select         auto
d-i    netcfg/use_autoconfig                           boolean        true
#d-i    netcfg/get_domain                               string         domain.com
#d-i    netcfg/get_hostname                             string         debian.domain.com

# Disk
d-i    partman-auto/disk                               string         /dev/sda
d-i    partman-auto/choose_recipe                      select         atomic
d-i    partman-auto/method                             string         regular
#d-i    partman-auto/method                             string         lvm
#d-i    partman-auto-lvm/guided_size                    string         max
#d-i    partman-lvm/confirm                             boolean        true
#d-i    partman-lvm/confirm_nooverwrite                 boolean        true
#d-i    partman-auto-lvm/new_vg_name                    string         debian-vg
d-i    partman-partitioning/confirm_write_new_label    boolean        true
d-i    partman/choose_partition                        select         finish
d-i    partman/confirm                                 boolean        true
d-i    partman/confirm_nooverwrite                     boolean        true

# Users
d-i    passwd/root-login                               boolean        false
#d-i    passwd/root-password-crypted                    password       REDACTED
d-i    passwd/root-password                            password       ${var.root_password}
d-i    passwd/root-password-again                      password       ${var.root_password}
d-i    passwd/make-user                                boolean        true
d-i    passwd/user-fullname                            string         Packer User
d-i    passwd/username                                 string         ${var.packer_username}
#d-i    passwd/user-password-crypted                    password       REDACTED
d-i    passwd/user-password                            password       ${var.packer_password}
d-i    passwd/user-password-again                      password       ${var.packer_password}
d-i    user-setup/allow-password-weak                  boolean        true
d-i    passwd/user-default-groups                      string         audio cdrom dip floppy video plugdev netdev scanner bluetooth debian-tor lpadmin sudo

# Mirror
d-i    mirror/codename                                 string         bookworm
d-i    mirror/http/countries                           select         NO
d-i    mirror/http/directory                           string         /debian/
d-i    mirror/http/hostname                            string         deb.debian.org
d-i    mirror/http/mirror                              select         deb.debian.org
d-i    mirror/http/proxy                               string
d-i    mirror/protocol                                 select         http
d-i    mirror/https/hostname                           string         deb.debian.org
d-i    mirror/https/mirror                             select         deb.debian.org

# Packages
d-i    base-installer/install-recommends               boolean        false
d-i    apt-setup/non-free-firmware                     boolean        true
d-i    apt-setup/contrib                               boolean        false
d-i    apt-setup/non-free                              boolean        false
d-i    apt-setup/use_mirror                            boolean        true
d-i    apt-setup/enable-source-repositories            boolean        true
d-i    apt-setup/disable-cdrom-entries                 boolean        true
d-i    apt-setup/services-select                       multiselect    security, updates
d-i    apt-setup/security_host                         string         security.debian.org
d-i    hw-detect/load_firmware                         boolean        true
d-i    pkgsel/update-policy                            select         none
d-i    pkgsel/updatedb                                 boolean        true
d-i    pkgsel/include                                  string         sudo debconf-utils lsb-release gnupg2 hyperv-daemons wget curl nfs-common cifs-utils rsync
d-i    pkgsel/run_tasksel                              boolean        true

# Tasksel
tasksel tasksel/first                                  multiselect    ssh-server

# Grub
d-i    grub-installer/choose_bootdev                   select         /dev/sda
d-i    grub-installer/only_debian                      boolean        true

# Finalize
d-i    preseed/late_command                            string         echo '${var.packer_username} ALL=(ALL) NOPASSWD:ALL' > /target/etc/sudoers.d/${var.packer_username}; chmod 0440 /target/etc/sudoers.d/${var.packer_username}
d-i    popularity-contest/participate                  boolean        false
d-i    finish-install/reboot_in_progress               note
