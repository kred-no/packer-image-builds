# PACKER-IMAGE-BUILDS

| Image              | azure | vsphere | vagrant | docker |
| :--                | :-:   | :-:     | :-:     | :-:    |
| Debian 11          | -     | -       | -       | -      |
| Debian 12          | -     | -       | OK      | -      |
| Ubuntu 20.04       | -     | -       | -       | -      |
| Ubuntu 24.04       | -     | -       | OK      | -      |
| Windows 11         | -     | -       | -       | -      |
| Windows 2022       | -     | -       | OK      | -      |
| ActiveMQ (Classic) | -     | -       | -       | -      |
| Payara Server      | -     | -       | -       | -      |


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
