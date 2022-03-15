#!/bin/bash
set -eu

export RPC_PORT="${RPC_PORT:-8545}"
export WS_PORT="${WS_PORT:-8546}"

if [[ ! -z "${ENDPOINT:-}"  ]]; then
    export RPC_ENDPOINT="${ENDPOINT}"
    export WS_ENDPOINT="${ENDPOINT}"
fi

if [[ ! -z "${ENDPOINT_FAILOVER:-}"  ]]; then
    export RPC_ENDPOINT_FAILOVER="${ENDPOINT_FAILOVER}"
    export WS_ENDPOINT_FAILOVER="${ENDPOINT_FAILOVER}"
fi

if [[ -z "${USERNAME:-}" || -z "${PASSWORD:-}" ]]; then
    envsubst '${RPC_PORT} ${RPC_ENDPOINT} ${WS_PORT} ${WS_ENDPOINT}' < /etc/nginx/conf.d/non-auth.conf.template > /etc/nginx/conf.d/default.conf
else
    export AUTHORIZATION=$(echo -n "${USERNAME}:${PASSWORD}" | base64 | tr -d \\n)
    envsubst '${RPC_PORT} ${WS_PORT} ${RPC_ENDPOINT} ${WS_ENDPOINT} ${RPC_ENDPOINT_FAILOVER} ${WS_ENDPOINT_FAILOVER} ${AUTHORIZATION}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf
fi

exec "$@"