#!/bin/bash
original_path1=`pwd`
root_path=$1
echo $1
cd $root_path
echo -e  $(ls *.root | sed "s:^:`pwd`/: ")|tr ' ' '\n'>${original_path1}/elec.list
cd $original_path1

