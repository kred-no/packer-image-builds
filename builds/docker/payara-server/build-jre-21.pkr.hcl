////////////////////////
// Sources
////////////////////////

source docker "default-jre-21" {
  image  = var.base_image_jre21
  commit = true // Committed & re-tagged in post-processing

  changes = [
    "ENV ADMIN_USER=admin",
    "ENV ADMIN_PASSWORD=admin",
    "ENV HOME_DIR=/opt/payara",
    "ENV PAYARA_DIR=$HOME_DIR/appserver",
    "ENV SCRIPT_DIR=$HOME_DIR/scripts",
    "ENV CONFIG_DIR=$HOME_DIR/config",
    "ENV DEPLOY_DIR=$HOME_DIR/deployments",
    "ENV PASSWORD_FILE=$HOME_DIR/passwordFile",
    "ENV JVM_ARGS=",
    "ENV MEM_MAX_RAM_PERCENTAGE=80.0",
    "ENV MEM_XSS=512k",
    "ENV DOMAIN_NAME='domain1'",
    "ENV PAYARA_ARGS=",
    "ENV DEPLOY_PROPS=",
    "ENV PATH=$PATH:$PAYARA_DIR/bin",
    "ENV PREBOOT_COMMANDS=$CONFIG_DIR/pre-boot-commands.asadmin",
    "ENV PREBOOT_COMMANDS_FINAL=$CONFIG_DIR/pre-boot-commands-final.asadmin",
    "ENV POSTBOOT_COMMANDS=$CONFIG_DIR/post-boot-commands.asadmin",
    "ENV POSTBOOT_COMMANDS_FINAL=$CONFIG_DIR/post-boot-commands-final.asadmin",
    "EXPOSE 8080 4848",
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

  //////////////////////
  // Provision
  //////////////////////

  # Copy files from runner
  provisioner "file" {
    generated = true

    sources = [
      format("%s/payara.zip", var.resource_folder),
      format("%s/postgres.jar", var.resource_folder),
      format("%s/mssql.jar", var.resource_folder),
      format("%s/activemq-rar.rar", var.resource_folder),
      "./files/startInForeground.sh",
    ]

    destination = "/tmp/"
  }

  provisioner "shell" {
    environment_vars = [
      "ADMIN_USER=admin",
      "ADMIN_PASSWORD=admin",
      "HOME_DIR=/opt/payara",
      "PAYARA_DIR=/opt/payara/appserver",
      "SCRIPT_DIR=/opt/payara/scripts",
      "CONFIG_DIR=/opt/payara/config",
      "DEPLOY_DIR=/opt/payara/deployments",
      "DOMAIN_NAME=domain1",
      "MEM_MAX_RAM_PERCENTAGE=80.0",
      "MEM_XSS=512k",
      "PASSWORD_FILE=/opt/payara/passwordFile",
    ]

    scripts = [
      "${path.root}/files/provisioning.default.sh",
    ]
  }

  //////////////////////
  // Create Entrypoint
  //////////////////////

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

  //////////////////////
  // Post-Processing
  //////////////////////

  provisioner "breakpoint" {
    disable = true
    note    = "Post-processing"
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
