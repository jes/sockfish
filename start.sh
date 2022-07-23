#!/bin/sh

cd /home/pi/sockfish
date >> LOG
cat screenlog.0 >> LOG
screen -L -d -m ./run
