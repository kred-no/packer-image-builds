#!/bin/bash

########################
# Validate environment
########################

if [ -z $ADMIN_USER ]; then echo "Variable ADMIN_USER is not set."; exit 1; fi
if [ -z $PASSWORD_FILE ]; then echo "Variable PASSWORD_FILE is not set."; exit 1; fi
if [ -z $PREBOOT_COMMANDS ]; then echo "Variable PREBOOT_COMMANDS is not set."; exit 1; fi
if [ -z $POSTBOOT_COMMANDS ]; then echo "Variable POSTBOOT_COMMANDS is not set."; exit 1; fi
if [ -z $DOMAIN_NAME ]; then echo "Variable DOMAIN_NAME is not set."; exit 1; fi

########################
## Create command files if they don't exist
########################

touch $PREBOOT_COMMANDS
touch $POSTBOOT_COMMANDS

########################
## > print the command line to the server with --dry-run, each argument on a separate line
## > remove -read-string argument
## > surround each line except with parenthesis to allow spaces in paths
## > remove lines before and after the command line and squash commands on a single line
########################

OUTPUT=`${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PASSWORD_FILE} start-domain --dry-run --prebootcommandfile=${PREBOOT_COMMANDS} --postbootcommandfile=${POSTBOOT_COMMANDS} $@ $DOMAIN_NAME`
STATUS=$?
if [ "$STATUS" -ne 0 ]
  then
    echo ERROR: $OUTPUT >&2
    exit 1
fi

COMMAND=`echo "$OUTPUT"\
 | sed -n -e '2,/^$/p'\
 | sed "s|glassfish.jar|glassfish.jar $JVM_ARGS |g"`

echo Executing Payara Server with the following command line:
echo $COMMAND | tr ' ' '\n'
echo

########################
## Run the server in foreground
## Read master password from variable or file
########################
set +x

if test "$AS_ADMIN_MASTERPASSWORD"x = x -a -f "$PASSWORD_FILE"
  then
    source "$PASSWORD_FILE"
fi
if test "$AS_ADMIN_MASTERPASSWORD"x = x
  then
    AS_ADMIN_MASTERPASSWORD=changeit
fi

echo "AS_ADMIN_MASTERPASSWORD=$AS_ADMIN_MASTERPASSWORD" > /tmp/masterpwdfile
exec ${COMMAND} < /tmp/masterpwdfile