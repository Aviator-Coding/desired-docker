#!/bin/bash

set -e
DESIRE_DATA=/home/desire/.desire
CONFIG_FILE=desire.conf

if [ -z "$1" ] || [ "$1" == "desired" ] || [ "$(echo "$1" | cut -c1)" == "-" ]; then
  cmd=desired
  shift

  if [ ! -d $DESIRE_DATA ]; then
    echo "$0: DATA DIR ($DESIRE_DATA) not found, please create and add config.  exiting...."
    exit 1
  fi

  if [ ! -f $DESIRE_DATA/$CONFIG_FILE ]; then
    echo "$0: desired config ($DESIRE_DATA/$CONFIG_FILE) not found, please create.  exiting...."
    exit 1
  fi

  chmod 700 "$DESIRE_DATA"
  chown -R desire "$DESIRE_DATA"

  if [ -z "$1" ] || [ "$(echo "$1" | cut -c1)" == "-" ]; then
    echo "$0: assuming arguments for desired"

    set -- $cmd "$@" -datadir="$DESIRE_DATA"
  else
    set -- $cmd -datadir="$DESIRE_DATA"
  fi

  if [ -n $MASTERNODE ] && [ "$MASTERNODE" == "1" ]; then
    echo "$0: This is a masternode, start the sentinel process..."
    /usr/bin/sentinel --config /home/desire/.desire/desire.conf > /var/log/sentinel.log 2>&1  &
  fi

  exec gosu desire "$@"
else
  echo "This entrypoint will only execute desired, desire-cli and desire-tx"
fi
