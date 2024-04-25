# ACTIVEMQ CLASSIC

## Base Image

  * container: azul/zulu-openjdk-debian:21-jre-headless
  * java-version: 21
  * os-version: debian-11
  * postgres jdbc driver included

## Usage

```bash
# Pull image
docker pull ghcr.io/kred-no/packer-image-builds/activemq-classic:6.1.1

# Run container
docker run --rm -it -p 8161:8161 ghcr.io/kred-no/packer-image-builds/activemq-classic:6.1.1
```

## External Resources

  * https://activemq.apache.org/components/classic/documentation/integrating-apache-activemq-classic-with-glassfish
  * https://blog.payara.fish/connecting-to-activemq-with-payara-server