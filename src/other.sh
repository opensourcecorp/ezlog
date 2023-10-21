#!/usr/bin/env bash
set -euo pipefail

export LOG_LEVEL_FATAL=1
export LOG_LEVEL_ERROR=2
export LOG_LEVEL_WARN=3
export LOG_LEVEL_INFO=4
export LOG_LEVEL_DEBUG=5

# ANSI color constants for log messages
export FATAL_COLOR='\033[0;31m' # red
export ERROR_COLOR='\033[1;31m' # light red
export WARN_COLOR='\033[1;33m'  # yellow
export INFO_COLOR='\033[1;32m'  # light green
export DEBUG_COLOR='\033[1;35m' # light purple
export RESET_COLOR='\033[0m'

_check-log-level() {
  # Defaults to info logs if not set
  LOG_LEVEL="${LOG_LEVEL:-${LOG_LEVEL_INFO}}"

  # Check for the possible string values of log levels as well. There is notably
  # no default case because we don't want to overwrite a valid integer either.
  case "${LOG_LEVEL}" in
    fatal)
      LOG_LEVEL="${LOG_LEVEL_FATAL}"
    ;;
    error)
      LOG_LEVEL="${LOG_LEVEL_ERROR}"
    ;;
    warn)
      LOG_LEVEL="${LOG_LEVEL_WARN}"
    ;;
    info)
      LOG_LEVEL="${LOG_LEVEL_INFO}"
    ;;
    debug)
      LOG_LEVEL="${LOG_LEVEL_DEBUG}"
    ;;
  esac

  printf '%s' "${LOG_LEVEL}"
}

_print-log-timestamp() {
  date '+%Y-%m-%dT%H:%M:%S'
}
