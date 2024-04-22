# UBUNTU BUILDS FOR VAGRANT

## Info

Ubuntu live-server uses the "Subiquity" installer. Subiquity supports a wrapped/customized cloud-init configuration, called 'autoinstall' ([docs](https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html)).

## Building

```bash
# Build specific build(s)
packer build -only="*hyperv-iso.*" .
packer build -only="HashiCluster*" .
```

