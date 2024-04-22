#!/usr/bin/env bash
set -ex

ANSIBLE_CONDITION=">=2.16.0"

sudo apt-get update
sudo apt-get -qqy satisfy "ansible (${ANSIBLE_CONDITION})"
