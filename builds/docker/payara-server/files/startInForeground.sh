#!/bin/bash
set -e

########################
# Validate environment
########################

if [ -z $ADMIN_USER ]; then echo "ADMIN_USER is not set."; exit 1; fi
if [ -z $PASSWORD_FILE ]; then echo "PASSWORD_FILE is not set."; exit 1; fi
if [ -z $PREBOOT_COMMANDS ]; then echo "PREBOOT_COMMANDS is not set."; exit 1; fi
if [ -z $POSTBOOT_COMMANDS ]; then echo "POSTBOOT_COMMANDS is not set."; exit 1; fi
if [ -z $DOMAIN_NAME ]; then echo "DOMAIN_NAME is not set."; exit 1; fi

########################
## Create command files if they don't exist
########################

touch $PREBOOT_COMMANDS
touch $POSTBOOT_COMMANDS

########################
## Print the command line with --dry-run
## Print each argument on a separate line
########################

OUTPUT=`${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} start-domain --dry-run --prebootcommandfile=${PREBOOT_COMMANDS} --postbootcommandfile=${POSTBOOT_COMMANDS} $@ $DOMAIN_NAME`

STATUS=$?
if [ "$STATUS" -ne 0 ]; then
  echo ERROR: $OUTPUT >&2
  exit 1
fi

# Add JVM_ARGS to command
COMMAND=`echo "$OUTPUT" \
 | sed -n -e '2,/^$/p' \
 | sed "s|glassfish.jar|glassfish.jar $JVM_ARGS |g"`

printf "\n.::.::.:( Running Payara Server with the following commands ):.::.::.\n\n"
printf "%s\n" $COMMAND | nl
echo

########################
## Default Keystore Password is 'changeit'
########################

set +x

if test "$AS_ADMIN_MASTERPASSWORD"x = x -a -f "$PASSWORD_FILE"; then
  source "$PASSWORD_FILE"
fi

if test "$AS_ADMIN_MASTERPASSWORD"x = x; then
  AS_ADMIN_MASTERPASSWORD=changeit
fi

echo "AS_ADMIN_MASTERPASSWORD=$AS_ADMIN_MASTERPASSWORD" > /tmp/masterpwdfile

########################
## Start server in foreground
########################

# Info
printf "\nPayara Server (Community Edition)\n"
printf "=================================\n"
printf "    System : %s\n" "$(cat /etc/issue.net)"
printf "  Hostname : %s\n" "$(hostname)"
printf "   Address : %s\n" "$(hostname -I)"
printf "\n\n"

exec $COMMAND < /tmp/masterpwdfile
