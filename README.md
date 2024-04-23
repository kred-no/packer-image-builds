# PACKER-IMAGE-BUILDS

| Image Name         | Azure | vSphere | Vagrant | Docker |
| :--                | :-:   | :-:     | :-:     | :-:    |
| Debian 11          | -     | -       | -       | -      |
| Debian 12          | -     | -       | yes     | -      |
| Ubuntu 20.04       | -     | -       | -       | -      |
| Ubuntu 24.04       | -     | -       | yes     | -      |
| Windows 11         | -     | -       | -       | -      |
| Windows 2022       | -     | -       | yes     | -      |
| ActiveMQ (Classic) | -     | -       | -       | yes    |
| Payara Server      | -     | -       | -       | yes    |

# Artifacts

  * [ghcr.io/kred-no/packer-image-builds/activemq-classic](https://github.com/kred-no/packer-image-builds/pkgs/container/packer-image-builds%2Factivemq-classic)
  * [ghcr.io/kred-no/packer-image-builds/payara-server](https://github.com/kred-no/packer-image-builds/pkgs/container/packer-image-builds%2Fpayara-server)

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

```bash
activemq_version=6.1.2 \
&& apt-get update && apt-get -qqy install curl \
&& mkdir -p /opt/activemq \
&& curl -L "https://archive.apache.org/dist/activemq/${activemq_version}/apache-activemq-${activemq_version}-bin.tar.gz" -o /tmp/amq.tar.gz \
&& tar -xzf /tmp/amq.tar.gz --strip-components=1 -C /opt/activemq
```
