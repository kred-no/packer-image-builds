# ACTIVEMQ CLASSIC

## Base Image

  * container: azul/zulu-openjdk-debian:21-jre-headless
  * java-version: 21
  * os-version: debian-11
  * postgres jdbc driver included

## Usage

```bash
# Pull image
docker pull ghcr.io/kred-no/packer-image-builds/activemq-classic:6.1.2

# Run container
docker run --rm -it -p 8161:8161 ghcr.io/kred-no/packer-image-builds/activemq-classic:6.1.2
```