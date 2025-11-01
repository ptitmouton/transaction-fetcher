#!/bin/bash

set +x

PINFILE="/pinfile.txt"

if [ ! -f "$PINFILE" ]; then
  >&2 echo "PIN file not found!"
  exit 1
fi

USER_UNIQUE_ID=$(./setup.sh | tail -n 1)

if [ -z "$USER_UNIQUE_ID" ]; then
  >&2 echo "No user id set"
  exit 1
fi

aqhbci-tool4 adduserflags -u "$USER_UNIQUE_ID" -f tlsIgnPrematureClose

aqhbci-tool4 getkeys -u "$USER_UNIQUE_ID"
aqhbci-tool4 sendkeys -u "$USER_UNIQUE_ID" -A

aqhbci-tool4 --acceptvalidcerts -n getbankinfo -u "$USER_UNIQUE_ID"
aqhbci-tool4 --acceptvalidcerts --pinfile=$PINFILE -n getsysid -u "$USER_UNIQUE_ID"

TANMODE="$(aqhbci-tool4 --acceptvalidcerts --pinfile=$PINFILE listitanmodes -u "$USER_UNIQUE_ID" | grep ": " | grep -v "not available" | tail -n 1)"

if [ -z "$TANMODE" ]; then
  >&2 echo "No TAN mode available"
  exit 1
fi

>&2 echo "Using TAN mode: $TANMODE"
TANMODE_ID=$(echo "$TANMODE" | awk '{print $2}')
>&2 echo "TAN mode ID: $TANMODE_ID"
aqhbci-tool4 --acceptvalidcerts -n setitanmode -u "$USER_UNIQUE_ID" -m 7946

>&2 echo "Fetching accounts for user $USER_UNIQUE_ID"
aqhbci-tool4 --acceptvalidcerts -n --pinfile=$PINFILE getaccounts -u "$USER_UNIQUE_ID"
>&2 echo "Accounts fetched."

>&2 echo "Listing accounts for user $USER_UNIQUE_ID:"
AVAILABLE_ACCOUNTS="$(aqhbci-tool4 -n --pinfile=$PINFILE listaccounts)"
>&2 echo "Accounts available: $AVAILABLE_ACCOUNTS"

if [ -z "$(echo "$AVAILABLE_ACCOUNTS" | grep "$ACCOUNT_ID")" ]; then
  >&2 echo "Account ID $ACCOUNT_ID not found in available accounts."
  exit 1
fi

>&2 echo "Fetching transactions and balance for account $ACCOUNT_ID"
OUTPUT="$(aqbanking-cli --acceptvalidcerts -n --pinfile=$PINFILE request --account=$ACCOUNT_ID --transactions --balance $@)"

echo "$OUTPUT" | aqbanking2json

