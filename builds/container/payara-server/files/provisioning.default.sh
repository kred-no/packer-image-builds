#!/usr/bin/env bash
set -eu

log(){
  printf "[%s] %s\n" "$(date -u)" "$1"
}

########################
## Script Environment
########################

ADMIN_USER=${admin_user:-"admin"}
ADMIN_PASSWORD=${admin_password:-"Admin123"}
HOME_DIR=${home_dir:-"/opt/payara"}
PAYARA_DIR=${payara_dir:-"${HOME_DIR}/appserver"}
SCRIPT_DIR=${script_dir:-"${HOME_DIR}/scripts"}
CONFIG_DIR=${config_dir:-"${HOME_DIR}/config"}
DEPLOY_DIR=${deploy_dir:-"${HOME_DIR}/deployments"}
DOMAIN_NAME=${domain_name:-"domain1"}
MEM_MAX_RAM_PERCENTAGE=${max_ram_percentage:-"80.0"}
MEM_XSS=${mem_xss:-"512k"}
PASSWORD_FILE=${password_file:-"/opt/payara/passwordFile"}
EXTRA_LOCALE=${extra_locale:-"nb_NO"}

########################
## Create Payara User & Folders
########################

log "Creating user"

mkdir -p ${HOME_DIR}
addgroup payara
adduser --system --no-create-home --shell /bin/bash --home ${HOME_DIR} --gecos "Payara User" --ingroup payara payara
echo payara:payara | chpasswd

########################
## Extra Locale(s)
########################

log "Adding locales"

for xlc in ${EXTRA_LOCALE};do
  sed -i "/${xlc}/s/^# \?//g" /etc/locale.gen;
done

locale-gen

########################
## Install Payara
########################

log "Installing Payara"

mkdir -p ${PAYARA_DIR}
mkdir -p ${DEPLOY_DIR}
mkdir -p ${CONFIG_DIR}
mkdir -p ${SCRIPT_DIR}

unzip -qq /tmp/payara.zip -d /tmp

mv /tmp/payara*/* ${PAYARA_DIR}/
mv /tmp/startInForeground.sh ${SCRIPT_DIR}/

########################
## Add Modules and Plugins
########################

mv /tmp/activemq-rar.rar ${PAYARA_DIR}/glassfish/modules

#mv /tmp/teams-notifier-console-plugin.jar ${PAYARA_DIR}/glassfish/modules/
#mv /tmp/teams-notifier-core.jar ${PAYARA_DIR}/glassfish/modules/
#mv /tmp/email-notifier-console-plugin.jar ${PAYARA_DIR}/glassfish/modules/
#mv /tmp/email-notifier-core.jar ${PAYARA_DIR}/glassfish/modules/

########################
## Configure Payara
########################

log "Configuring Payara"

printf "AS_ADMIN_PASSWORD=\nAS_ADMIN_NEWPASSWORD=${ADMIN_PASSWORD}" > /tmp/password-change-file.txt
printf "AS_ADMIN_PASSWORD=${ADMIN_PASSWORD}" >> ${PASSWORD_FILE}
${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=/tmp/password-change-file.txt change-admin-password --domain_name=${DOMAIN_NAME}

${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} start-domain ${DOMAIN_NAME}
${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} enable-secure-admin

for MEMORY_JVM_OPTION in $(${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} list-jvm-options | grep "Xm[sx]\|Xss"); do
  ${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} delete-jvm-options $MEMORY_JVM_OPTION;
done

${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} create-jvm-options '-XX\:+UseContainerSupport:-XX\:MaxRAMPercentage=${ENV=MEM_MAX_RAM_PERCENTAGE}:-Xss${ENV=MEM_XSS}'
${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=${PASSWORD_FILE} add-library --type common /tmp/postgres.jar
${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=${PASSWORD_FILE} add-library --type common /tmp/mssql.jar
${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} set-log-attributes com.sun.enterprise.server.logging.UniformLogFormatter.ansiColor=true
${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} set-log-attributes com.sun.enterprise.server.logging.GFFileHandler.logtoFile=false
${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} set-log-attributes com.sun.enterprise.server.logging.GFFileHandler.logtoConsole=true
${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} set-log-attributes com.sun.enterprise.server.logging.GFFileHandler.formatter='fish.payara.enterprise.server.logging.JSONLogFormatter'
${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} set-log-attributes java.util.logging.ConsoleHandler.formatter='fish.payara.enterprise.server.logging.JSONLogFormatter' 
${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=${PASSWORD_FILE} set-healthcheck-configuration --enabled=true

${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} stop-domain --kill=true ${DOMAIN_NAME}

########################
## Finalize
########################

log "Finishing up"

chmod +x ${SCRIPT_DIR}/*.sh
rm -rf ${PAYARA_DIR}/glassfish/domains/${DOMAIN_NAME}/osgi-cache ${PAYARA_DIR}/glassfish/domains/${DOMAIN_NAME}/logs
chown -R payara:payara ${HOME_DIR}

log "Done!"

exit 0