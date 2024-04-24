# PACKER-IMAGE-BUILDS

## Overview

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

## Artifacts

### Containers

| Name | Build Status |
| :--  | :--          |
| [activemq-classic](https://github.com/kred-no/packer-image-builds/pkgs/container/packer-image-builds%2Factivemq-classic) | ![activemq-classic](https://img.shields.io/github/actions/workflow/status/kred-no/packer-image-builds/build-container-activemq-classic.yml) |
| [payara-server](https://github.com/kred-no/packer-image-builds/pkgs/container/packer-image-builds%2Fpayara-server)       | ![payara-server](https://img.shields.io/github/actions/workflow/status/kred-no/packer-image-builds/build-container-payara-server.yml)       |

