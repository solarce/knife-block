#!/usr/bin/env bash

# helper script to install chefdk for testing on travis-ci

ubuntu_check(){
  grep 'Ubuntu' /etc/issue

  if [[ $? != 0 ]]; then
    echo "This is only meant to run on Ubuntu!"
    exit 1
  fi
}

install_chefdk() {
  CHEF_DK_VERSION="0.4.0-1"
  CHEF_DK_URL=https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_"$CHEF_DK_VERSION"_amd64.deb
  CHEF_DK_DEB=/tmp/chefdk_"$CHEF_DK_VERSION"_installer.deb
  curl -s $CHEF_DK_URL -o $CHEF_DK_DEB
  sudo dpkg -i $CHEF_DK_DEB # > /dev/null 2>&1
  chef verify # > /dev/null 2>&1
  chefdk_installed_correctly=$?
  if [[ $chefdk_installed_correctly != 0 ]]; then
    echo "ChefDK not installed correctly, failing"
    exit 1
  fi
  eval "$(chef shell-init bash)"
}

if [[ -n $1 ]]; then
  if [[ $1 == true ]]; then
    ubuntu_check
    echo "installing chefdk"
    install_chefdk
  else
    exit 0
  fi
else
  echo "Doing nothing >:-3"
  exit 0
fi
