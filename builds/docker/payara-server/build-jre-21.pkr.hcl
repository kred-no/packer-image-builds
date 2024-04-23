////////////////////////
// Sources
////////////////////////

source docker "default-jre-21" {
  image  = var.base_image_jre21
  commit = true // Committed & re-tagged in post-processing

  // Update Container

  changes = [
    format("ENV %s=%s", "ADMIN_USER", var.payara_admin_username),
    #format("ENV %s=%s", "ADMIN_PASSWORD", var.payara_admin_password),
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
    format("ENV %s=%s", "PREBOOT_COMMANDS_FINAL", "$CONFIG_DIR/pre-boot-commands-final.asadmin"),
    format("ENV %s=%s", "POSTBOOT_COMMANDS", "$CONFIG_DIR/post-boot-commands.asadmin"),
    format("ENV %s=%s", "POSTBOOT_COMMANDS_FINAL", "$CONFIG_DIR/post-boot-commands-final.asadmin"),
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
  sources = ["source.docker.default-jre-21"]

  // Provisioning

  provisioner "file" {
    sources = [
      "${path.root}/files/startInForeground.sh",
      "${path.root}/files/pre-jdbc-postgres.sh",
      "${path.root}/files/pre-jdbc-mssql-jre11.sh",
      "${path.root}/files/pre-activemq-rar.sh",
      "${path.root}/files/pre-payara-server.sh",
    ]

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
      "${path.root}/files/provisioning.default.sh",
    ]
  }

  // Entrypoint

  provisioner "file" {
    content     = <<-HEREDOC
      #!/bin/bash
      set -x
      for f in $SCRIPT_DIR/init_* $SCRIPT_DIR/init.d/*; do
        case "$f" in
          *.sh)  echo "[Entrypoint] running $f"; . "$f" ;;
          *)     echo "[Entrypoint] ignoring $f" ;;
        esac
        echo
      done

      exec $SCRIPT_DIR/startInForeground.sh $PAYARA_ARGS
      HEREDOC
    destination = "/usr/local/bin/docker-entrypoint.sh"
  }

  provisioner "shell" {
    inline = ["chmod +rx /usr/local/bin/docker-entrypoint.sh"]
  }

  // Post-Processing

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
