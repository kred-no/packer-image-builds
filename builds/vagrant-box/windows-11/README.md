# README.md

Create an updated, basic Windows 11 box for use in Vagrant

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

## External References

  * https://developer.hashicorp.com/packer/integrations
  * https://developer.hashicorp.com/packer/integrations/hashicorp/hyperv/latest/components/builder/iso