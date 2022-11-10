# PACKER-IMAGE-BUILDS

| Version              | OS      | Target  | Builder | Status  |
| :--                  | :--     | :--     | :--     | :-:     |
| Windows Server 2k22  | Windows | Azure   | Packer  | Working |
| Windows Desktop 11   | Windows | Azure   | Packer  | Working |
| Debian 11 (Bullseye) | Linux   | Azure   | Packer  | Working |
| Windows Server 2k22  | Windows | vSphere | Packer  | Working |
| Ubuntu 22.04 (Jammy) | Linux   | vSphere | Packer  | Working |


## Build Workflow

  1. Prepare source-image (set up SSH/WinRM access & authentication).

      * Tools (Linux): Cloud-Init/Kickstart
      * Tools (Windows): Autounattend+Powershell

  2. Provision/configure image.
      
      * Tools (Windows): Powershell, Chocolatey
      * Tools (Linux): Shell, Ansible
  
  3. Generalize, shutdown & save the finished image.


## Deployment

Deployment/specialization can be done using your preferred toolchain. This can be Terraform, Ansible or something else.
Specialization (e.g. adding application config, etc.) should also be done in this step, unless the built images are very specialized.
