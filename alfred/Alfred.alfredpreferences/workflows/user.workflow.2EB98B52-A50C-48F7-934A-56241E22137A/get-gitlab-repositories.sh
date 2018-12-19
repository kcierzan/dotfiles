#!/bin/bash

GIT_DIRECTORY=~/git/

find $GIT_DIRECTORY -name config -maxdepth 3 \
  | grep '\.git' \
  | xargs cat \
  | grep gitlab.aweber.io \
  | awk -F'gitlab.aweber.io' '{ print substr($2, 2) }' \
  | sed s/\.git//
