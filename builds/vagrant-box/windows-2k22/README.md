# README.md

## Unattended Installation

  * https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/update-windows-settings-and-scripts-create-your-own-answer-file-sxs?view=windows-11
  * https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/how-configuration-passes-work?view=windows-11

**The “settings” options in the autounattend.xml file are executed in the following order:**

  1. windowsPE: These settings are used by the Windows Setup installation program1.
  1. offlineServicing: These settings are applied to offline images where you apply an Unattend file with DISM using the Apply-Unattend option.
  1. generalize: This configuration pass prepares the system for imaging and deployment.
  1. specialize: Most settings should be added here. These settings are triggered both at the beginning of audit mode and at the beginning of OOBE.
  1. auditSystem: This configuration pass runs immediately after the system has been generalized.
  1. auditUser: Runs as soon as you start audit mode.
  1. oobeSystem: Use sparingly. Most of these settings run after the user completes OOBE.

## Guides

  * https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/update-windows-settings-and-scripts-create-your-own-answer-file-sxs?view=windows-11
  * https://github.com/LukeCarrier/packer-windows/blob/master/scripts/core/shutdown.ps1
  * https://learn.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/

## Tools

Adding files to windows installation (e.g. unattend.xml files), requires an ISO creation tool (xorriso, mkisofs, hdiutil, oscdimg) installed & available.

  * [Windows: oscdimg.exe](https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install#download-the-adk-101253981-september-2023) ("C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\x86\Oscdimg\")
  * [cdrtools](https://opensourcepack.blogspot.com/p/cdrtools.html)
  * xorriso


## Notes

```bash
# See
# > https://developer.hashicorp.com/packer/integrations/hashicorp/hyperv/latest/components/builder/iso#example-for-windows-server-2012-r2-generation-2
# > https://github.com/rgl/windows-vagrant/blob/master/windows-2022.pkr.hcl
# > https://gist.github.com/Dlfaith/0d43be3dfb296bb6260af75ef082faa8?permalink_comment_id=4834292
# > https://massgrave.dev/genuine-installation-media.html
#
# Standard:
# > HP9DJ-NK2X6-4QPCH-8HY8H-6X2XY
# > RRNMT-FP29D-CHKCH-GWQP2-DDDVB
# > 44QN4-X3R72-9X3VK-3DWD6-HFWDM
#
# Datacenter:
# > WX4NM-KYWYW-QJJR4-XV3QB-6VM33
```

## Ansible

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