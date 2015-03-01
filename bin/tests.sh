#!/usr/bin/env bash -x

# Check if there is an argument for chefdk

if [[ -n $1 ]]; then
  CHEF_DK_INSTALL=$1
  if [[ $CHEF_DK_INSTALL == true ]]; then
    source ./bin/chef_dk_install.sh
    ubuntu_check
    echo "Installing chefdk"
    install_chefdk
  fi
fi

bundle install --jobs=3 --retry=3
bundle exec rake

