#!/bin/bash
if [ "$(dpkg --print-architecture)" == "arm64" ]; then
  FILENAME="aqbanking2json-linux-arm64"
else
  FILENAME="aqbanking2json-linux-x64"
fi
wget "https://github.com/ptitmouton/aqbanking2json/releases/download/v0.0.3/$FILENAME" -O /usr/local/bin/aqbanking2json
chmod +x /usr/local/bin/aqbanking2json

exit 0
