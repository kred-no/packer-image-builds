#!/usr/bin/env bash
set -eu

apt-get -qqy remove openssl # Security
apt-get -qqy autoclean

rm -rf /var/lib/apt/lists/* 
rm -rf /tmp/*

exit 0