#!/bin/bash

ENV=$1

if [ -z "$ENV" ]; then
	echo "Usage: ./init.sh <dev|staging|prod>"
	exit 1
fi

BACKEND_FILE="backend/${ENV}.backend"

if [ ! -f "$BACKEND_FILE" ]; then
	echo "Backend config for '${ENV}' not found."
	exit 1
fi

terraform init -reconfigure -backend-config="$BACKEND_FILE"
