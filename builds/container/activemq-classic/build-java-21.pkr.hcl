////////////////////////
// Sources
////////////////////////

source docker "azul-java-21" {
  image  = "azul/zulu-openjdk-debian:21-jre-headless"
  commit = true // Committed & re-tagged in post-processing

  changes = [
    format("ENV %s=%s", "ACTIVEMQ_HOME", "/opt/activemq"),
    format("ENV %s=%s", "ACTIVEMQ_CONF", "/opt/activemq/conf"),
    format("ENV %s=%s", "ACTIVEMQ_DATA", "/opt/activemq/data"),
    format("ENV %s=%s", "ACTIVEMQ_TMP", "/tmp"),
    format("ENV %s=%s", "ACTIVEMQ_USER", "activemq"),
    "EXPOSE 5672 8161 61616",
    "VOLUME /opt/activemq/data",
    "USER activemq",
    "WORKDIR /opt/activemq",
    "ENTRYPOINT [\"/usr/local/bin/docker-entrypoint.sh\"]",
    "CMD [\"\"]",
  ]
}

////////////////////////
// Builds
////////////////////////

build {
  name    = "azul-jre-21"
  sources = ["source.docker.azul-java-21"]

  //////////////////////
  // Provision
  //////////////////////

  provisioner "breakpoint" {
    disable = true
    note    = "Provisioning"
  }

  provisioner "shell" {
    environment_vars = [
      join("=", ["postgres_jdbc_version", var.postgres_jdbc_version]),
      join("=", ["activemq_version", var.activemq_version]),
    ]

    scripts = [
      "${path.root}/files/init.sh",
      "${path.root}/files/get-postgres-jdbc.sh",
      "${path.root}/files/get-activemq.sh",
      "${path.root}/files/provisioning.sh",
      "${path.root}/files/finalize.sh",
    ]
  }

  //////////////////////
  // Entrypoint
  //////////////////////

  provisioner "file" {
    content     = <<-HEREDOC
      #!/usr/bin/env bash
      bin/activemq console
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
      #repository = "local/activemq"
      repository = var.repository

      tags = [
        var.activemq_version,
        format("%s-latest", var.activemq_version),
        format("%s-%s", var.activemq_version, local.timestamp),
      ]
    }

    post-processor "docker-push" {
      name = "push"

      login          = true
      login_server   = var.registry_server
      login_username = var.registry_username
      login_password = var.registry_password
    }
  }
}
