# README.md

Create an updated, basic Windows Server 2022 box for use in Vagrant

**Credentials**

  * Username: vagrant
  * Password: vagrant
  * OpenSSH-Server: Enabled
  * RemoteDesktopService: Enabled

## Hypervisor Support Matrix

| Hypervisor | Supported |
| :--        | :-:       |
| HyperV     | x         |
| VMware     |           |
| Virtualbox |           |
| QEMU/KVM   |           |

## Building

**Requirements**

  1. HasihCorp Packer installed
  1. Microsoft HyperV Enabled
  1. oscdimg.exe in build-path (from Windows ADK)

**Build Commands**

```bash
# Download/update plugins
packer init -upgrade .

# Validate configuration
packer validate .

# Build image
packer build .
```

**Vagrant Commands**

```bash
# Add box
vagrant box add "<path-to-box-from-build>" --name="<box-name-in-vagrant>"

# Remove box
vagrant box remove "<box-name-in-vagrant>"
```

## Using Ansible

See https://docs.ansible.com/ansible/2.9/modules/list_of_windows_modules.html

```bash
# Example Uses
ansible all -i hosts.yml -m win_ping
ansible all -i hosts.yml -m win_whoami
ansible all -i hosts.yml -m win_file -a "path=C:\hello.txt state=touch"
```

**Hosts-file**

```yml
all:
  hosts:
    win:
      ansible_host: 172.24.52.121
      ansible_user: vagrant
      ansible_password: vagrant
      ansible_connection: ssh
      ansible_shell_type: cmd
```

## External References

  * https://developer.hashicorp.com/packer/integrations
  * https://developer.hashicorp.com/packer/integrations/hashicorp/hyperv/latest/components/builder/iso
  * https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/update-windows-settings-and-scripts-create-your-own-answer-file-sxs?view=windows-11
  * https://github.com/LukeCarrier/packer-windows/blob/master/scripts/core/shutdown.ps1
  * https://learn.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/
  * https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install#download-the-adk-101253981-september-2023
