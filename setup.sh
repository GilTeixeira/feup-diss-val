#!/bin/sh


## Setup parsers
npm install --prefix sonarqube-parser/
npm install --prefix parser/

# ## Setup Analizo
# git clone https://github.com/GilTeixeira/analizo
# cd analizo
# sh development-setup.sh
# cd ..


# ## Setup ckjm
# git clone https://github.com/GilTeixeira/ckjm
# cd ckjm
# make
# cd ..


## Setup LARA-clava
# mkdir lara
# mkdir lara/clava
# wget http://specs.fe.up.pt/tools/clava.zip -P ./lara/clava
# unzip lara/clava/clava.zip -d lara/clava/
# rm lara/clava/clava.zip

# ## Setup LARA-kadabra
# mkdir lara
# mkdir lara/kadabra
# wget http://specs.fe.up.pt/tools/kadabra.zip -P ./lara/kadabra
# unzip lara/kadabra/kadabra.zip -d lara/kadabra/
# rm lara/kadabra/kadabra.zip


## Setup LARA-Metrics
# git clone https://github.com/GilTeixeira/feup-diss


## Setup test projects

### Setup elasticsearch
mkdir -p test
git clone https://github.com/GilTeixeira/elasticsearch
mv elasticsearch test
gradle wrapper -p test/elasticsearch/buildSrc/

#git clone https://github.com/GilTeixeira/axios
#git clone https://github.com/GilTeixeira/libphonenumber
#git clone https://github.com/GilTeixeira/json
#git clone https://github.com/GilTeixeira/gson