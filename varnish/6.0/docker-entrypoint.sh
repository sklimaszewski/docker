#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

function _gotpl {
    if [[ -f "/etc/gotpl/$1" ]]; then
        gotpl "/etc/gotpl/$1" > "$2"
    fi
}

init_varnish_secret() {
    if [[ -z "${VARNISH_SECRET}" ]]; then
        export VARNISH_SECRET=$(pwgen -s 128 1)
        echo "Generated Varnish secret: ${VARNISH_SECRET}"
    fi

    echo -e "${VARNISH_SECRET}" > /etc/varnish/secret
}

init_purge_key() {
    if [[ -z "${VARNISH_PURGE_KEY}" ]]; then
        export VARNISH_PURGE_KEY=$(pwgen -s 64 1)
        echo "Varnish purge key is missing. Generating random: ${VARNISH_PURGE_KEY}"
    fi
}

process_templates() {
    _gotpl 'varnishd.init.d.tmpl' '/etc/init.d/varnishd'
}

init_varnish_secret
init_purge_key
process_templates

exec_init_scripts

if [[ "${1}" == "make" ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    exec $@
fi