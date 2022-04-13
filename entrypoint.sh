#!/bin/bash
set -eu

export DNS="${DNS}"
export RPC_PORT="${RPC_PORT:-8545}"
export WS_PORT="${WS_PORT:-8546}"
export WS="${WS:-'YES'}"

if [[ ! -z "${ENDPOINT:-}"  ]]; then
    export RPC_ENDPOINT="${ENDPOINT}"
    export WS_ENDPOINT="${ENDPOINT}"
fi

echo $WS

if [[ -z "${USERNAME:-}" || -z "${PASSWORD:-}" ]] && [[ "$WS" = "YES" ]]; then
    echo "hecho"
    envsubst '${DNS} ${RPC_PORT} ${RPC_ENDPOINT} ${WS_PORT} ${WS_ENDPOINT}' < /etc/nginx/conf.d/non-auth.conf.template > /etc/nginx/conf.d/default.conf
elif [[ -z "${USERNAME:-}" || -z "${PASSWORD:-}" ]] && [[ "$WS" = "NO" ]]; then
    envsubst '${DNS} ${RPC_PORT} ${RPC_ENDPOINT}' < /etc/nginx/conf.d/rpc.non-auth.conf.template > /etc/nginx/conf.d/default.conf
elif [[ "$WS" = "YES" ]]; then
    export AUTHORIZATION=$(echo -n "${USERNAME}:${PASSWORD}" | base64 | tr -d \\n)
    envsubst '${DNS} ${RPC_PORT} ${WS_PORT} ${RPC_ENDPOINT} ${WS_ENDPOINT} ${AUTHORIZATION}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf
else
    export AUTHORIZATION=$(echo -n "${USERNAME}:${PASSWORD}" | base64 | tr -d \\n)
    envsubst '${DNS} ${RPC_PORT} ${RPC_ENDPOINT} ${AUTHORIZATION}' < /etc/nginx/conf.d/rpc.default.conf.template > /etc/nginx/conf.d/default.conf
fi

exec "$@"