#!/usr/bin/env bash
set -euo pipefail

export EZLOG_LEVEL_FATAL=1
export EZLOG_LEVEL_ERROR=2
export EZLOG_LEVEL_WARN=3
export EZLOG_LEVEL_INFO=4
export EZLOG_LEVEL_DEBUG=5

# ANSI color constants for log messages, starting as color-coded and removing
# them if terminal does not support enough colors
export FATAL_COLOR='\033[0;31m' # red
export ERROR_COLOR='\033[1;31m' # light red
export WARN_COLOR='\033[1;33m'  # yellow
export INFO_COLOR='\033[1;32m'  # light green
export DEBUG_COLOR='\033[1;35m' # light purple
export RESET_COLOR='\033[0m'

_set-for-term-colors() {
  if [[ "$(tput colors)" -lt 8 ]] ; then
    export FATAL_COLOR=''
    export ERROR_COLOR=''
    export WARN_COLOR=''
    export INFO_COLOR=''
    export DEBUG_COLOR=''
    export RESET_COLOR=''
  fi
}

_check-log-level() {
  # Defaults to info logs if not set
  EZLOG_LEVEL="${EZLOG_LEVEL:-${EZLOG_LEVEL_INFO}}"

  # Check for the possible string values of log levels as well. There is notably
  # no default case because we don't want to overwrite a valid integer either.
  case "${EZLOG_LEVEL}" in
    fatal)
      EZLOG_LEVEL="${EZLOG_LEVEL_FATAL}"
    ;;
    error)
      EZLOG_LEVEL="${EZLOG_LEVEL_ERROR}"
    ;;
    warn)
      EZLOG_LEVEL="${EZLOG_LEVEL_WARN}"
    ;;
    info)
      EZLOG_LEVEL="${EZLOG_LEVEL_INFO}"
    ;;
    debug)
      EZLOG_LEVEL="${EZLOG_LEVEL_DEBUG}"
    ;;
  esac

  printf '%s' "${EZLOG_LEVEL}"
}

_print-log-timestamp() {
  EZLOG_TIMESTAMP="${EZLOG_TIMESTAMP:-true}"
  if [[ "${EZLOG_TIMESTAMP}" == true ]] ; then
    printf '[%s] ' "$(date '+%Y-%m-%dT%H:%M:%S')"
  fi
}
