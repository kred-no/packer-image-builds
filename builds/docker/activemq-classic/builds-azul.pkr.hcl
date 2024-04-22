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

  provisioner "breakpoint" {
    disable = true
    note    = "Pre-Provisioning"
  }

  provisioner "shell-local" {
    #execute_command = ["/bin/bash", "-c", "{{.Vars}}", "{{.Script}}"]
    execute_command = [
      "chmod", "+x", "{{.Script}}", ";",
      "/bin/bash", "-c",
      "{{.Vars}}", "{{.Script}}",
    ]
    
    environment_vars = [
      format("activemq_version=%s", var.activemq_version),
      format("jdbc_version=%s", var.postgres_jdbc_version),
      format("hawtio_version=%s", var.hawtio_version),
    ]

    scripts = [
      "${path.root}/files/pre-provisioning-activemq.sh",
      "${path.root}/files/pre-provisioning-postgres.sh",
      "${path.root}/files/pre-provisioning-hawtio.sh",
    ]
  }

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
      "${path.root}/files/cache/apache-activemq-bin.tar.gz",
      "${path.root}/files/cache/postgresql.jar",
      "${path.root}/files/cache/hawtio-default.war",
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
    #source      = "${path.root}/files/docker-entrypoint.debian.sh"
    content = <<-HEREDOC
      #!/usr/bin/env bash
      bin/activemq console
      HEREDOC
    destination = "/usr/local/bin/docker-entrypoint.sh"
  }

  provisioner "shell" {
    inline = [
      "chmod +rx /usr/local/bin/docker-entrypoint.sh"
    ]
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
      repository = "local/activemq"

      tags = [
        "latest",
        var.activemq_version,
        local.timestamp,
      ]
    }

    /*
    post-processor "docker-push" {
      name = "push"

      login          = true
      login_server   = "xx"
      login_username = "xx"
      login_password = "xx"
    }*/
  }
}
