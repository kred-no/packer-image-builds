#!/usr/bin/env bash
set +x -eu -o pipefail

log(){
  printf "[%s] %s\n" "$(date -u)" "$1"
}

########################
## Environment
########################

BUILD_UI=${build_ui:-""}
GO_VERSION=${golang_version:-"1.22.2"}
GOPATH="/opt/go"
#OPENBAO_VERSION=

########################
## Install OS Packages
########################

log "Installing OS packages"

echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
apt-get update
apt-get -qqy install apt-utils > /dev/null 2>&1
apt-get -qqy install unzip curl tar
apt-get -qqy install make git

# Vault UI
if [[ $BUILD_UI ]]; then
  apt-get -qqy install npm # nodejs implied
  npm install --global yarn
fi

########################
## Install Golang
########################

log "Installing Golang"

rm -rf /usr/local/go
curl -L "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz
tar -xzf /tmp/go.tar.gz -C /usr/local
rm -f /tmp/go.tar.gz

export PATH="$PATH:/usr/local/go/bin"

########################
## Install OpenBao
########################

log "Cloning OpenBao"

mkdir -p $GOPATH/src/github.com/openbao && cd $_
#git clone https://github.com/openbao/openbao.git
git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/openbao/openbao.git
cd openbao

log "Building OpenBao"

make bootstrap
make dev

if [[ $BUILD_UI ]]; then
  log "Embedding OpenBao UI into binary"
  make static-dist
  make dev-ui
fi

log "Installing OpenBao"

install ./bin/bao /usr/local/bin
bao -h

########################
## Cleaning up UI Packages
########################

if [[ $BUILD_UI ]]; then
  npm uninstall --global yarn
fi

########################
## Cleaning up #######################

log "Cleaning up"

apt-get -qqy purge unzip make git
apt-get -qqy purge npm perl
apt-get -qqy autoclean
apt-get -qqy autoremove

rm -rf /opt/go
rm -rf /usr/local/go
rm -rf ~/go
rm -rf ~/.go
rm -rf ~/.cache

if [[ $BUILD_UI ]]; then
  rm -rf ~/.npm
  rm -rf /usr/share/nodejs
  rm -rf ~/.yarn
fi

rm -rf /var/lib/apt/lists/* 
rm -rf /tmp/*

rm -rf /usr/share/doc
rm -rf /usr/share/man

########################
## Done
########################

log "Finished!"

exit 0