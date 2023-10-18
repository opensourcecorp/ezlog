#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091,SC2046,SC2086
source "$(dirname $(realpath ${BASH_SOURCE[0]}))"/other.sh

log-fatal() {
  LOG_LEVEL="$(_check-log-level)"
  if [[ "${LOG_LEVEL}" -ge "${LOG_LEVEL_FATAL}" ]] ; then
    printf '%b[%s] (FATAL) %s%b\n' "${FATAL_COLOR}" "$(_print-log-timestamp)" "$@" "${RESET_COLOR}" >&2
    return 1
  fi
}

log-error() {
  LOG_LEVEL="$(_check-log-level)"
  if [[ "${LOG_LEVEL}" -ge "${LOG_LEVEL_ERROR}" ]] ; then
    printf '%b[%s] (ERROR) %s%b\n' "${ERROR_COLOR}" "$(_print-log-timestamp)" "$@" "${RESET_COLOR}" >&2
  fi
}

log-warn() {
  LOG_LEVEL="$(_check-log-level)"
  if [[ "${LOG_LEVEL}" -ge "${LOG_LEVEL_WARN}" ]] ; then
    printf '%b[%s] (WARN)  %s%b\n' "${WARN_COLOR}" "$(_print-log-timestamp)" "$@" "${RESET_COLOR}"
  fi
}

log-info() {
  LOG_LEVEL="$(_check-log-level)"
  if [[ "${LOG_LEVEL}" -ge "${LOG_LEVEL_INFO}" ]] ; then
    printf '%b[%s] (INFO)  %s%b\n' "${INFO_COLOR}" "$(_print-log-timestamp)" "$@" "${RESET_COLOR}"
  fi
}

log-debug() {
  LOG_LEVEL="$(_check-log-level)"
  if [[ "${LOG_LEVEL}" -ge "${LOG_LEVEL_DEBUG}" ]] ; then
    printf '%b[%s] (DEBUG) %s%b\n' "${DEBUG_COLOR}" "$(_print-log-timestamp)" "$@" "${RESET_COLOR}"
  fi
}
