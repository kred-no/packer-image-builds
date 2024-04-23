#!/usr/bin/env bash
set -eu

log(){
  printf "[%s] %s\n" "$(date -u)" "$1"
}

########################
## Configure OS
########################

log "Installing OS packages"

apt-get update
apt-get -qqy install unzip curl tar

########################
## Create Payara User & Folders
########################

log "Creating user"

mkdir -p ${HOME_DIR}
addgroup payara
adduser --system --no-create-home --shell /bin/bash --home ${HOME_DIR} --gecos "Payara User" --ingroup payara payara
echo payara:payara | chpasswd

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
mv /tmp/activemq-rar.rar ${PAYARA_DIR}/

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

${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=${PASSWORD_FILE} add-library --type common /tmp/postgres.jar
${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=${PASSWORD_FILE} add-library --type common /tmp/mssql.jar
${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} create-jvm-options '-XX\:+UseContainerSupport:-XX\:MaxRAMPercentage=${ENV=MEM_MAX_RAM_PERCENTAGE}:-Xss${ENV=MEM_XSS}'
${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} set-log-attributes com.sun.enterprise.server.logging.GFFileHandler.logtoFile=false
${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} stop-domain ${DOMAIN_NAME}

########################
## Finalize
########################

log "Finishing up"

chown -R payara:payara ${HOME_DIR}
chmod +x ${SCRIPT_DIR}/*.sh

apt-get -qqy remove openssl # Security
rm -rf /var/lib/apt/lists/* 
rm -rf ${PAYARA_DIR}/glassfish/domains/${DOMAIN_NAME}/osgi-cache ${PAYARA_DIR}/glassfish/domains/${DOMAIN_NAME}/logs
rm -rf /tmp/*

log "Done!"

exit 0