#!/bin/bash 

# Install Sonar-scanner-cli-4.6.2.2472
wget "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip"
unzip sonar-scanner-cli-4.6.2.2472-linux.zip
rm sonar-scanner-cli-4.6.2.2472-linux.zip
mv sonar-scanner-4.6.2.2472-linux/ sonar-server

# Install plugins for Sonarqube
mkdir plugins
wget "https://github.com/SonarOpenCommunity/sonar-cxx/releases/download/cxx-2.0.4/sonar-cxx-plugin-2.0.4.2806.jar"
mv  sonar-cxx-plugin-2.0.4.2806.jar plugins/ 