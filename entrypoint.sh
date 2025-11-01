#!/bin/bash

set -x

./create-pinfile.sh
./fetch-transactions.sh $@
