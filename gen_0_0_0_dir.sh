#!/bin/bash
cd $1
find . -type d -print|grep 0_0_0$ > $2/dir_0_0_0.list
cd $2

