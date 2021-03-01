#!/usr/bin/env sh
set -eu

export RPC_PORT="${RPC_PORT:-8545}"
export WS_PORT="${WS_PORT:-8546}"
export AUTHORIZATION=$(echo -n "${USERNAME}:${PASSWORD}" | base64 | tr -d \\n)

envsubst '${RPC_PORT} ${RPC_ENDPOINT} ${WS_PORT} ${WS_ENDPOINT} ${AUTHORIZATION}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

exec "$@"