# PACKER-IMAGE-BUILDS (PUBLIC)

## Overview

| Image Name         | Azure | vSphere | Vagrant | Docker |
| :--                | :-:   | :-:     | :-:     | :-:    |
| Debian 11          | -     | -       | -       | -      |
| Debian 12          | -     | -       | yes     | -      |
| Ubuntu 20.04       | -     | -       | -       | -      |
| Ubuntu 24.04       | -     | -       | yes     | -      |
| Windows 11         | -     | -       | yes     | -      |
| Windows 2022       | -     | -       | yes     | -      |
| ActiveMQ (Classic) | -     | -       | -       | yes    |
| Payara Server      | -     | -       | -       | yes    |
| OpenBao            | -     | -       | -       | yes    |

## Artifacts

N/A

### Containers

| Name | Build Status |
| :--  | :--          |
| [activemq-classic](https://github.com/kred-no/packer-image-builds/pkgs/container/packer-image-builds%2Factivemq-classic) | ![activemq-classic](https://img.shields.io/github/actions/workflow/status/kred-no/packer-image-builds/build-container-activemq-classic.yml) |
| [payara-server](https://github.com/kred-no/packer-image-builds/pkgs/container/packer-image-builds%2Fpayara-server)       | ![payara-server](https://img.shields.io/github/actions/workflow/status/kred-no/packer-image-builds/build-container-payara-server.yml)       |
| [openbao](https://github.com/kred-no/packer-image-builds/pkgs/container/packer-image-builds%2Fopenbao)                   | ![openbao](https://img.shields.io/github/actions/workflow/status/kred-no/packer-image-builds/build-container-openbao.yml)       |
```bash
docker pull ghcr.io/kred-no/packer-image-builds/activemq-classic:6.1.1
docker pull ghcr.io/kred-no/packer-image-builds/payara-server:6.2024.4
```
