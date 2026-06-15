#!/usr/bin/env bash

# Source this file from a project that contains hpc_mac:
#   source hpc_mac/hpc_aliases.sh

_hpc_find_bundle() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/hpc_mac" ]]; then
      printf "%s\n" "$dir/hpc_mac"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

_hpc_run() {
  local bundle
  bundle="$(_hpc_find_bundle)" || {
    echo "hpc_mac folder not found from $PWD" >&2
    return 1
  }
  bash "$bundle/bin/$1" "${@:2}"
}

hpcsetup() { _hpc_run hpc-setup "$@"; }
hpcsync() { _hpc_run hpc-sync-to-cluster "$@"; }
hpcsubmit() { _hpc_run hpc-submit "$@"; }
hpcstatus() { _hpc_run hpc-status "$@"; }
hpcfetch() { _hpc_run hpc-fetch-results "$@"; }
hpcshell() { _hpc_run hpc-shell "$@"; }
hpccancel() { _hpc_run hpc-cancel-last "$@"; }

alias hpcls='ls -ltrh'
