#!/bin/bash

echo "This pull request is opened by $PR_AUTHOR."

DIR="./assignments/$(echo $PR_TITLE | grep -o -E '[0-9]+')"
if [ -d "$DIR" ]; then
  echo "Directory ${DIR} exists. Now checking if test.vhd file exists..."
  cd $DIR
else
  echo "Error: ${DIR} not found. Aborting..."
  exit 1
fi

if test -f test.vhd; then
    echo "File test.vhd exists. Checking syntax..."
    ghdl -s test.vhd
else
    echo "File test.vhd does not exist. Aborting..."
    exit 1
fi
