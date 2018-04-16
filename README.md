# desired-docker
desire (DSR) Daemon / Wallet Blockchain in Docker

This container uses the cryptocoin-base container (https://quay.io/repository/kwiksand/cryptocoin-base) which installs ubuntu and all the bitcoin build dependencies (miniupnp, berkelyDB 4.8, system build tools, etc)

## Usage

This repository contains the docker build if you'd like to manually build, but also points back at the quay.io docker build image (i.e `docker pull quay.io/kwiksand/desired:latest`).

To setup in the simplest way:
* Install docker-ce (any recent docker version) on your machine/VPS/Raspberry Pi
* Checkout git repository - `git clone https://github.com/kwiksand/desired-docker.git`
* Make a directory for the wallet/blockchain/logs to sit/write to - `mkdir /media/crypto/desire`
* Edit docker-compose.yml, changing the volume line to the directory chosen above:
```bash
  volumes:
   - /media/crypto/desire:/home/desire/.desire
```
* Copy the example config, moving it to the directory chosen above:
```bash
  cp desire.conf.example /media/crypto/desire/desire.conf
```
* Edit the new config, changing the username and password (something long/random)
* Start via docker-compose - `docker-compose up -d`
* After a short while downloading the image and starting the container you should start to see the directory (/media/crypto/desire) fill with content
* Wait for the blockchain sync to complete - `tail -f /media/crypto/desire/debug.log`

By this stage you have a working desire wallet/blockchain setup, now we need to set up the masternode itself:

test
