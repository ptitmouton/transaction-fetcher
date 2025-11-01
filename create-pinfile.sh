#!/bin/sh

pinfile="/pinfile.txt"

if [ -f "$pinfile" ]; then
  >&2 echo "PIN file already exists!"
  exit 1
fi

>&2 echo "Creating PIN file..."

if [ -z "$USERID" ]; then
  >&2 echo "No USERID set"
  exit 1
fi
if [ -z "$BANK" ]; then
  >&2 echo "No BANK set"
  exit 1
fi
if [ -z "$PIN" ]; then
  >&2 echo "No PIN set"
  exit 1
fi

echo "PIN_${BANK}_${USERID} = \"${PIN}\"" > $pinfile
