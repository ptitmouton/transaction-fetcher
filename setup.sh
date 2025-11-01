#!/bin/sh

set +x

USER_DETAILS=$(aqhbci-tool4 listusers | grep "$USERID")
if [ -n "$USER_DETAILS" ]; then
  USER_UNIQUE_ID=${USER_DETAILS##* }
  echo "$USER_UNIQUE_ID"
  exit 0
fi

if [ -z "$CUSTOMERID" ]; then
  >&2 echo "No CUSTOMERID set"
  exit 1
fi

case "$BANK" in
  "43060967")
    >&2 echo "Using bank code for GLS-Bank"
    aqhbci-tool4 adduser \
      --tokentype="pintan" \
      --username="transaction-fetcher" \
      --bank="$BANK" \
      --server="https://fints1.atruvia.de/cgi-bin/hbciservlet" \
      --user="$USERID" \
      --customer="$CUSTOMERID" \
      --hbciversion=300
    ;;
  *)
    >&2 echo "Unsupported bank code: $BANK"
    exit 1
    ;;
esac

USER_DETAILS=$(aqhbci-tool4 listusers | grep "$USERID")

>&2 echo "User details: $USER_DETAILS"

USER_UNIQUE_ID=${USER_DETAILS##* }

echo "$USER_UNIQUE_ID"
exit 0

