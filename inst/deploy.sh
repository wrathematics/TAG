#!/bin/sh

#----------------------------------------------------------------
# This script should deploy TAG on a new Ubuntu 14.04 vm.
#----------------------------------------------------------------

export MAKE="/usr/bin/make -j 9"   # I recommend ncores+1


### Preliminaries
sudo dd if=/dev/zero of=/swap bs=1M count=1024
sudo mkswap /swap
sudo swapon /swap
sudo cat "/swap swap swap defaults 0 0" >> /etc/fstab

sudo apt-get update 
yes | sudo apt-get upgrade
sudo apt-get install git tmux openjdk-7-jre openjdk-7-jdk libgsl0-dev libxml2-dev libclang-3.6-dev clang-3.5 git


### Set up R
sudo cat "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt-get update
sudo apt-get install r-base-dev
sudo R CMD javareconf


### Get devtools
sudo apt-get install libcurl4-openssl-dev
echo "options(repos=structure(c(CRAN='http://cran.rstudio.com/')))" | sudo tee --append /etc/R/Rprofile.site > /dev/null
sudo Rscript -e "install.packages('devtools')"


### Install shiny server
sudo Rscript -e "install.packages('shiny')"
cd /tmp
wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.3.0.403-amd64.deb
sudo gdebi shiny-server-1.3.0.403-amd64.deb


### Install TAG - this will take a while!
sudo Rscript -e "devtools::install_github('XSEDEScienceGateways/TAG')"
TAGPATH=`Rscript -e "cat(file.path(system.file('tag', package='TAG')))"`
sudo cp -r $TAGPATH /srv/shiny-server

