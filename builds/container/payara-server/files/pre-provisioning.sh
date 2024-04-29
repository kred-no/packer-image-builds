#!/usr/bin/env bash
set -eu

echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
apt-get update
apt-get -qqy install apt-utils > /dev/null 2>&1
apt-get -qqy install unzip curl tar
apt-get -qqy install maven

exit 0