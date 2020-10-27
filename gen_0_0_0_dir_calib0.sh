#!/bin/bash
cd $1
find . -type d -print|grep ".*photon.*0_0_0$" > $2/dir_0_0_0.list
find . -type d -print|grep "C14$" >> $2/dir_0_0_0.list
cd $2

