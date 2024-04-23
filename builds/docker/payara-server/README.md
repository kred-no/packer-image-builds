# PAYARA SERVER

## Image Content

  * payara server
  * Java JRE: 21
  * OS: Debian-11
  * MSSQL JDBC driver: included
  * Postgres JDBC driver: included
  * ActiveMQ Client: included ${PAYARA_DIR}/activemq-rar.rar

## Official Payara References

  * [Release Notes](https://docs.payara.fish/community/docs/Release%20Notes/Overview.html)
  * [Documentation](https://docs.payara.fish/community/docs/Overview.html)
  * [Download Payara](https://www.payara.fish/downloads/payara-platform-community-edition/)
  * [Dockerfile](https://raw.githubusercontent.com/payara/Payara/0063b41409aa4d1bd0e3c7e5e3e5f8643e634faf/appserver/extras/docker-images/server-full/src/main/docker/Dockerfile)

## Usage

```bash
# Pull image
docker pull ghcr.io/kred-no/packer-image-builds/payara-server:6.2024.4

# Run container
docker run --rm -it -p 8080:8080 ghcr.io/kred-no/packer-image-builds/payara-server:6.2024.4
```
