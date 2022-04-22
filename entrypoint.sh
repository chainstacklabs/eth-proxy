#!/bin/bash
set -eu

export DNS="${DNS}"
export PORT="${RPC_PORT:-80}"
export WS="${WS:-"NO"}"
export STATUS_METHOD="${STATUS_METHOD:-net_version}"

if [[ ! -z "${ENDPOINT:-}"  ]]; then
    export RPC_ENDPOINT="${ENDPOINT}"
    export WS_ENDPOINT="${ENDPOINT}"
else
    export RPC_ENDPOINT="${RPC_ENDPOINT}"
    export WS_ENDPOINT="${WS_ENDPOINT}"
fi

if [[ -z "${USERNAME:-}" || -z "${PASSWORD:-}" ]] && [[ "$WS" = "YES" ]]; then
    # WS and no auth
    envsubst '${DNS} ${PORT}' < /tmp/rpc.ws.non-auth.conf.template > /etc/nginx/conf.d/default.conf
elif [[ -z "${USERNAME:-}" || -z "${PASSWORD:-}" ]]; then
    # no ws and no auth
    envsubst '${DNS} ${PORT}' < /tmp/rpc.non-auth.conf.template > /etc/nginx/conf.d/default.conf
elif [[ "$WS" = "YES" ]]; then
    # ws and auth
    export AUTHORIZATION=$(echo -n "${USERNAME}:${PASSWORD}" | base64 | tr -d \\n)
    envsubst '${DNS} ${PORT} ${AUTHORIZATION}' < /tmp/rpc.ws.auth.conf.template > /etc/nginx/conf.d/default.conf
else
    # no ws and auth
    export AUTHORIZATION=$(echo -n "${USERNAME}:${PASSWORD}" | base64 | tr -d \\n)
    envsubst '${DNS} ${PORT} ${AUTHORIZATION}' < /tmp/rpc.auth.default.conf.template > /etc/nginx/conf.d/default.conf
fi

envsubst '${STATUS_METHOD}' < /tmp/status.template  > /etc/nginx/conf.d/status.template 
envsubst '${RPC_ENDPOINT}' < /tmp/rpc.template  > /etc/nginx/conf.d/rpc.template 
envsubst '${WS_ENDPOINT}' < /tmp/ws.template  > /etc/nginx/conf.d/ws.template 

exec "$@"