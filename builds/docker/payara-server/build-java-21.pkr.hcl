////////////////////////
// Sources
////////////////////////

source docker "default-java-21" {
  image  = var.base_image_java_21
  commit = true // Re-tagged in post-processing

  // Update Container

  changes = [
    format("ENV %s=%s", "ADMIN_USER", var.payara_admin_username),
    format("ENV %s=%s", "HOME_DIR", "/opt/payara"),
    format("ENV %s=%s", "PAYARA_DIR", "$HOME_DIR/appserver"),
    format("ENV %s=%s", "SCRIPT_DIR", "$HOME_DIR/scripts"),
    format("ENV %s=%s", "CONFIG_DIR", "$HOME_DIR/config"),
    format("ENV %s=%s", "DEPLOY_DIR", "$HOME_DIR/deployments"),
    format("ENV %s=%s", "PASSWORD_FILE", "$HOME_DIR/passwordFile"),
    format("ENV %s=%s", "JVM_ARGS", ""),
    format("ENV %s=%s", "MEM_MAX_RAM_PERCENTAGE", "80.0"),
    format("ENV %s=%s", "MEM_XSS", "512k"),
    format("ENV %s=%s", "DOMAIN_NAME", "domain1"),
    format("ENV %s=%s", "PAYARA_ARGS", ""),
    format("ENV %s=%s", "DEPLOY_PROPS", ""),
    format("ENV %s=%s", "PATH", "$PATH:$PAYARA_DIR/bin"),
    format("ENV %s=%s", "PREBOOT_COMMANDS", "$CONFIG_DIR/pre-boot-commands.asadmin"),
    format("ENV %s=%s", "POSTBOOT_COMMANDS", "$CONFIG_DIR/post-boot-commands.asadmin"),
    format("ENV %s=%s", "TZ", "Europe/Oslo"),
    format("ENV %s=%s", "LC_ALL", "nb_NO.ISO-8859-1"),
    join(" ", ["EXPOSE", "8080", "4848"]),
    "VOLUME /opt/payara/data",
    "USER payara",
    "WORKDIR /opt/payara",
    "ENTRYPOINT [\"/usr/local/bin/docker-entrypoint.sh\"]",
    "CMD [\"\"]",
  ]
}

////////////////////////
// Builds
////////////////////////

build {
  name    = "jre-21"
  sources = ["source.docker.default-java-21"]

  // Provisioning

  provisioner "breakpoint" {
    disable = true
    note    = "provisioning"
  }

  provisioner "file" {
    source      = "${path.root}/files/startInForeground.sh"
    destination = "/tmp/"
  }

  provisioner "shell" {
    environment_vars = [
      join("=", ["admin_user", var.payara_admin_username]),
      join("=", ["admin_password", var.payara_admin_password]),
      join("=", ["postgres_jdbc_version", var.postgres_jdbc_version]),
      join("=", ["mssql_jdbc_version", var.mssql_jdbc_version]),
      join("=", ["activemq_version", var.activemq_version]),
      join("=", ["payara_version", var.payara_version]),
    ]

    scripts = [
      "${path.root}/files/pre-provisioning.sh",
      "${path.root}/files/get-jdbc-postgres.sh",
      "${path.root}/files/get-jdbc-mssql-jre11.sh",
      "${path.root}/files/get-activemq-rar.sh",
      #"${path.root}/files/get-notifiers.sh", # Payara 5.x.x ?
      "${path.root}/files/get-payara-server.sh",
      "${path.root}/files/provisioning.default.sh",
      "${path.root}/files/post-provisioning.sh",
    ]
  }

  // Entrypoint

  provisioner "file" {
    source      = "${path.root}/files/docker-entrypoint.sh"
    destination = "/usr/local/bin/docker-entrypoint.sh"
  }

  provisioner "shell" {
    inline = ["chmod +rx /usr/local/bin/docker-entrypoint.sh"]
  }

  // Post-Processing

  provisioner "breakpoint" {
    disable = true
    note    = "post-processing"
  }

  post-processors {

    post-processor "docker-tag" {
      repository = var.repository

      tags = [
        var.payara_version,
        format("%s-latest", var.payara_version),
        format("%s-%s", var.payara_version, local.timestamp),
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
