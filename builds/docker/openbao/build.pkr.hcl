////////////////////////
// Sources
////////////////////////

source docker "stable" {
  image  = var.base_image
  commit = true // Committed & re-tagged in post-processing

  changes = [
    format("ENV %s=%s", "OPENBAO_USER", "bao"),
    "EXPOSE 8200",
    "VOLUME /data",
    "USER root",
    "WORKDIR /opt/bao",
    "ENTRYPOINT [\"/usr/local/bin/docker-entrypoint.sh\"]",
    #"CMD [\"server\",\"-dev\",\"-dev-listen-address='0.0.0.0:8200'\",\"-dev-root-token-id='root'\"]",
    "CMD []",
  ]
}

////////////////////////
// Builds
////////////////////////

build {
  name = "default"

  sources = [
    "source.docker.stable",
  ]

  //////////////////////
  // Provision
  //////////////////////

  provisioner "breakpoint" {
    disable = true
    note    = "Provisioning"
  }

  provisioner "shell" {
    environment_vars = [
      join("=", ["openbao_version", var.openbao_version]),
      join("=", ["golang_version", var.golang_version]),
      join("=", ["build_ui", var.build_ui]),
    ]

    scripts = [
      "${path.root}/files/provision.full.sh",
    ]
  }

  //////////////////////
  // Entrypoint
  //////////////////////

  provisioner "file" {
    content     = <<-HEREDOC
      #!/usr/bin/env bash
      #TODO - create proper entrypoint-script
      exec /usr/local/bin/bao $@
      HEREDOC
    destination = "/usr/local/bin/docker-entrypoint.sh"
  }

  provisioner "shell" {
    inline = ["chmod +rx /usr/local/bin/docker-entrypoint.sh"]
  }

  //////////////////////
  // Post-Processing
  //////////////////////

  provisioner "breakpoint" {
    disable = true
    note    = "Post-processing"
  }

  post-processors {

    post-processor "docker-tag" {
      repository = var.target_repository

      tags = [
        var.openbao_version,
        format("%s-%s", var.openbao_version, local.timestamp),
      ]
    }

    post-processor "docker-push" {
      name = "push"

      login          = true
      login_server   = var.target_registry_server
      login_username = var.target_registry_username
      login_password = var.target_registry_password
    }
  }
}
