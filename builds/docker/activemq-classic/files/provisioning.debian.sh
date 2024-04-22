#!/usr/bin/env bash
set -eu

log () {
  printf "[%s] %s\n" "$(date -u)" "${1}"
}

# Validation
if [ ! -f "/tmp/apache-activemq-bin.tar.gz" ];then log "Missing ActiveMQ!";exit 1;fi
if [ ! -f "/tmp/postgresql.jar" ];then log "Missing Postgres JDBC driver!";exit 1;fi
if [ ! -f "/tmp/hawtio-default.war" ];then log "Missing HawtIO!";exit 1;fi

TEMPDIR=/tmp
ACTIVEMQ_HOME=/opt/activemq
ACTIVEMQ_USER=activemq

# //////////////////////
# Installation
# //////////////////////

mkdir -p ${ACTIVEMQ_HOME}
tar -xzf ${TEMPDIR}/apache-activemq-bin.tar.gz --strip-components=1 -C ${ACTIVEMQ_HOME}
rm -rf ${TEMPDIR}/apache-activemq-bin.tar.gz


# //////////////////////
# Customization
# //////////////////////

sed -i 's/127.0.0.1/0.0.0.0/g' "${ACTIVEMQ_HOME}/conf/jetty.xml"
sed -i 's/127.0.0.1/0.0.0.0/g' "${ACTIVEMQ_HOME}/conf/activemq.xml"

# v5.x.x
#sed -ri 's/^(\s*)ACTIVEMQ_OPTS_MEMORY=(.*)/\1ACTIVEMQ_OPTS_MEMORY="-XX:MaxRAMPercentage=85.0 -XX:InitialRAMPercentage=85.0 -XX:+ExitOnOutOfMemoryError"/g' "${ACTIVEMQ_HOME}/bin/env"

# v6.x.x
sed -ri 's/^(\s*)ACTIVEMQ_OPTS_MEMORY=(.*)/\1ACTIVEMQ_OPTS_MEMORY="-XX:MaxRAMPercentage=85.0 -XX:InitialRAMPercentage=85.0 -XX:+ExitOnOutOfMemoryError"/g' "${ACTIVEMQ_HOME}/bin/setenv"

# //////////////////////
# Drivers
# //////////////////////

mkdir -p ${ACTIVEMQ_HOME}/lib/optional
mv ${TEMPDIR}/postgresql.jar ${ACTIVEMQ_HOME}/lib/optional/

# //////////////////////
# HawtIO
# //////////////////////

mkdir -p ${ACTIVEMQ_HOME}/webapps/hawtio/
mv ${TEMPDIR}/hawtio-default.war ${ACTIVEMQ_HOME}/lib/optional/

# //////////////////////
# // Users & Permissions
# //////////////////////

useradd --comment "ActiveMQ user" --base-dir /home --home-dir ${ACTIVEMQ_HOME} --no-create-home --system --user-group ${ACTIVEMQ_USER}
chown -R ${ACTIVEMQ_USER}:${ACTIVEMQ_USER} ${ACTIVEMQ_HOME}

exit 0
