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
  #CHEF_DK_VERSION="0.4.0-1"
  #CHEF_DK_URL=https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_"$CHEF_DK_VERSION"_amd64.deb
  #CHEF_DK_DEB=/tmp/chefdk_"$CHEF_DK_VERSION"_installer.deb
  ubuntu_check
  #curl -s $CHEF_DK_URL -o $CHEF_DK_DEB
  #sudo dpkg -i $CHEF_DK_DEB > /dev/null 2>&1
  curl https://packagecloud.io/gpg.key | sudo apt-key add -
  echo "deb https://packagecloud.io/chef/stable/ubuntu/ precise main" \
    | sudo tee -a /etc/apt/sources.list.d/chef.list
  sudo apt-get install -y apt-transport-https
  sudo apt-get update -qq
  sudo apt-get install -y chefdk
  chef verify > /dev/null 2>&1
  chefdk_installed_correctly=$?
  if [[ $chefdk_installed_correctly != 0 ]]; then
    echo "ChefDK not installed correctly, failing"
    exit 1
  fi
  eval "$(chef shell-init bash)"
}

