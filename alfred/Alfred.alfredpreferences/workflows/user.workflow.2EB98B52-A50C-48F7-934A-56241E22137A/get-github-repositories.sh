#!/bin/bash

GIT_DIRECTORY=~/git/

find $GIT_DIRECTORY -name config -maxdepth 3 \
  | grep '\.git' \
  | xargs cat \
  | grep github.aweber.io \
  | awk -F'github.aweber.io' '{ print substr($2, 2) }' \
  | sed s/\.git//
