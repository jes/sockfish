#!/bin/sh

echo "welcome" > /home/pi/welcome

cd /home/pi/sockfish
screen -d -m ./run
