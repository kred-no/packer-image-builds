#!/usr/bin/env bash
set -e

log(){
  printf "[%s] %s\n" "$(date -u)" "$1"
}

OUTDIR=${outdir:-"/tmp"}
TEAMS_VERSION=${notifier_teams_version:-"2.0"}
EMAIL_VERSION=${notifier_email_version:-"2.0"}

# Notifiers are placed in: ${PAYARA_DIR}/glassfish/modules

pushd ${OUTDIR}

# Teams Notifier
TEAMS_CONSOLE_URL="https://nexus.payara.fish/repository/payara-artifacts/fish/payara/extensions/notifiers/teams-notifier-console-plugin/${TEAMS_VERSION}/teams-notifier-console-plugin-${TEAMS_VERSION}.jar"
TEAMS_CORE_URL="https://nexus.payara.fish/repository/payara-artifacts/fish/payara/extensions/notifiers/teams-notifier-core/${TEAMS_VERSION}/teams-notifier-core-${TEAMS_VERSION}.jar"

log "[Notifier] Downloading Teams Notifier Plugin"
curl --silent --retry 3 -L "${TEAMS_CONSOLE_URL}" -o teams-notifier-console-plugin.jar.sha1
curl --silent --retry 3 -L "${TEAMS_CONSOLE_URL}" -o teams-notifier-console-plugin.jar

curl --silent --retry 3 -L "${TEAMS_CORE_URL}" -o teams-notifier-core.jar.sha1
curl --silent --retry 3 -L "${TEAMS_CORE_URL}" -o teams-notifier-core.jar

# Email Notifier
EMAIL_CONSOLE_URL="https://nexus.payara.fish/repository/payara-artifacts/fish/payara/extensions/notifiers/email-notifier-console-plugin/${EMAIL_VERSION}/email-notifier-console-plugin-${EMAIL_VERSION}.jar"
EMAIL_CORE_URL="https://nexus.payara.fish/repository/payara-artifacts/fish/payara/extensions/notifiers/email-notifier-core/${EMAIL_VERSION}/email-notifier-core-${EMAIL_VERSION}.jar"

log "[Notifier] Downloading Email Notifier Plugin"
curl --silent --retry 3 -L "${EMAIL_CONSOLE_URL}" -o email-notifier-console-plugin.jar.sha1
curl --silent --retry 3 -L "${EMAIL_CONSOLE_URL}" -o email-notifier-console-plugin.jar

curl --silent --retry 3 -L "${EMAIL_CORE_URL}" -o email-notifier-core.jar.sha1
curl --silent --retry 3 -L "${EMAIL_CORE_URL}" -o email-notifier-core.jar

popd
