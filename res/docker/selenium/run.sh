#!/usr/bin/env bash

cd /selenium
java -jar selenium.jar -role hub &
Xvfb :10 -ac -screen 0 1600x1200x24 &
export DISPLAY=:10
java -jar selenium.jar -DUnexpectedAlertBehaviour=ignore -role node -hub http://127.0.0.1:4444/grid/register &

tail -F /dev/null