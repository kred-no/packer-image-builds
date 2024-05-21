# ACTIVEMQ CLASSIC

## Base Image

  * Container: azul/zulu-openjdk-debian (headless)
  * Extra Drivers: postgres (jdbc)

## Example Use

```bash
# Pull Docker image
docker pull ghcr.io/kred-no/packer-image-builds/activemq-classic:6.1.1

# Run standalone container
docker run --rm -it -p 8161:8161 ghcr.io/kred-no/packer-image-builds/activemq-classic:6.1.1

# Run compose container
docker compose run -f ./compose.yml up
```

```yaml
# ./compose.yml
services:
  activemq:
    image: ghcr.io/kred-no/packer-image-builds/activemq-classic:6.1.2
    hostname: activemq
    deploy:
      resources:
        limits:
          cpus: '0.1'
          memory: 384M
    volumes:
    - type: bind
      source: ./users.properties
      target: /opt/activemq/conf/users.properties
    - type: bind
      source: ./groups.properties
      target: /opt/activemq/conf/groups.properties
    ports: ["5672:5672", "8161:8161"]
```

## Build Process

  1. PreStage
  1. BuildStage
  1. PostStage

## External Resources

  * https://activemq.apache.org/components/classic/documentation/integrating-apache-activemq-classic-with-glassfish
  * https://blog.payara.fish/connecting-to-activemq-with-payara-server