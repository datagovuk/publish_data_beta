#!/bin/bash

CF=`command -v cf`
echo $CF

if [[ -z $CF ]]
then
  echo 'cf not found, installing'
  wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
  echo "deb http://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
  sudo apt-get update
  sudo apt-get install cf-cli
fi

if [[ -z $CF_API ]]
then
  echo 'CF_API is not set'
  exit 1
fi

if [[ -z $CF_USER ]]
then
  echo 'CF_USER is not set'
  exit 1
fi

if [[ -z $CF_PASS ]]
then
  echo 'CF_PASS is not set'
  exit 1
fi

if [[ -z $CF_SPACE ]]
then
  echo 'CF_SPACE is not set'
  exit 1
fi

CF_APP=$1
CF_ENV=$2
if [[ -z $CF_APP ]]
then
  echo 'please specify the app you wish to push to as your first argument'
  exit 1
fi

if [[ -z $CF_ENV ]]
then
  CF_ENV='staging'
fi


cf login -a $CF_API -u $CF_USER -p $CF_PASS -s $CF_SPACE
cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org
cf install-plugin blue-green-deploy -r CF-Community -f
cf bgd $CF_APP -f $CF_ENV-manifest.yml
