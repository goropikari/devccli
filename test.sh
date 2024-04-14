#!/bin/bash

set -e

sudo ls

function error () {
  bash -c "echo $1 && exit 1"
}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DEVC=${SCRIPT_DIR}/devc
for d in dockerCompose dockerComposeCloneVolume ; do
    cd $SCRIPT_DIR/$d
    git init
    $DEVC up
    $DEVC up
    $DEVC exec ls
    $DEVC stop
    $DEVC stop
    $DEVC down
    $DEVC down && error 'error expected'
    rm -rf .git
done

for d in dockerfile ; do
    cd $SCRIPT_DIR/$d
    git init
    $DEVC up false
    $DEVC up false
    $DEVC exec ls
    $DEVC stop
    $DEVC stop
    $DEVC down
    $DEVC down && error 'error expected'
    rm -rf .git
done

cd $SCRIPT_DIR/dockerfile
git init
devc up true && error 'error expected'
rm -rf .git

echo tests passed
