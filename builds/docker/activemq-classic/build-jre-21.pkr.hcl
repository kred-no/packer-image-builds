////////////////////////
// Sources
////////////////////////

source docker "azul-jre-21" {
  image  = "azul/zulu-openjdk-debian:21-jre-headless"
  commit = true // Committed & re-tagged in post-processing

  changes = [
    "ENV ACTIVEMQ_HOME /opt/activemq",
    "ENV ACTIVEMQ_CONF /opt/activemq/conf",
    "ENV ACTIVEMQ_DATA /opt/activemq/data",
    "ENV ACTIVEMQ_TMP  /tmp",
    "ENV ACTIVEMQ_USER activemq",
    "EXPOSE 5672 8161",
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
  sources = ["source.docker.azul-jre-21"]

  //////////////////////
  // Pre-Provision (Local)
  //////////////////////

  /* FAILS when using github workflow
  provisioner "shell-local" {
    environment_vars = [
      format("resource_folder=%s", var.resource_folder),
      format("activemq_version=%s", var.activemq_version),
      format("jdbc_version=%s", var.postgres_jdbc_version),
      format("hawtio_version=%s", var.hawtio_version),
    ]

    scripts = [
      "${path.root}/files/pre-provisioning-activemq.sh",
      "${path.root}/files/pre-provisioning-postgres.sh",
      "${path.root}/files/pre-provisioning-hawtio.sh",
    ]
    
    execute_command = ["/bin/bash", "-c", "{{ .Vars }}", "{{ .Script }}"]
  }*/

  //////////////////////
  // Provision
  //////////////////////

  provisioner "breakpoint" {
    disable = true
    note    = "Provisioning"
  }

  provisioner "file" {
    generated = true

    sources = [
      format("%s/apache-activemq-bin.tar.gz", var.resource_folder),
      format("%s/postgresql.jar", var.resource_folder),
    ]

    destination = "/tmp/"
  }

  provisioner "shell" {
    scripts = [
      "${path.root}/files/provisioning.debian.sh",
    ]
  }

  //////////////////////
  // Add Entrypoint
  //////////////////////

  provisioner "file" {
    content = <<-HEREDOC
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
