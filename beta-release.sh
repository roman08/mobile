#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

flutter packages get
flutter clean

echo "${green}Building Android...${reset}"
flutter build apk --release
cd ./android && fastlane deploy_beta