#!/bin/bash
set -eu

export RPC_PORT="${RPC_PORT:-8545}"
export WS_PORT="${WS_PORT:-8546}"

if [[ -z "${USERNAME:-}" || -z "${USERNAME:-}" ]]; then
    envsubst '${RPC_PORT} ${RPC_ENDPOINT} ${WS_PORT} ${WS_ENDPOINT}' < /etc/nginx/conf.d/non-auth.conf.template > /etc/nginx/conf.d/default.conf
else
    export AUTHORIZATION=$(echo -n "${USERNAME}:${PASSWORD}" | base64 | tr -d \\n)
    envsubst '${RPC_PORT} ${RPC_ENDPOINT} ${WS_PORT} ${WS_ENDPOINT} ${AUTHORIZATION}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf
fi

exec "$@"