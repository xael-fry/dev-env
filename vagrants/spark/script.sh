#!/bin/bash
# Author- Alexandre Chatiron

echo -e "\n--- Updating packages list ---\n"
sudo apt-get update -y

echo -e "\n--- Installing vim ---\n"
sudo apt-get -y install vim

echo -e "\n--- Installing openjdk ---\n"
sudo apt-get -y install openjdk-7-jdk

echo -e "\n--- Installing spark ---\n"
wget http://d3kbcqa49mib13.cloudfront.net/spark-1.2.0-bin-hadoop1.tgz
tar -zxf spark-1.2.0-bin-hadoop1.tgz

