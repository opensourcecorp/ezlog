#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091,SC2046,SC2086
source "$(dirname $(realpath ${BASH_SOURCE[0]}))"/main.sh

test_logfile="./test.log"
rm -f "${test_logfile}" && touch "${test_logfile}"

fail-test() {
  log-error "FAIL - $*"
  log-error "FAIL - $*" >> "${test_logfile}" 2>&1
}

check-failures() {
  if [[ "$(cat ${test_logfile} | wc -l)" -eq 0 ]] ; then
    log-info 'All tests passed!'
  else
    log-fatal 'Tests failed! Review above.'
  fi
}

export EZLOG_LEVEL=''
log-info 'Running tests...'

### All log levels set
EZLOG_LEVEL="${EZLOG_LEVEL_DEBUG}"

log-debug test | grep test || {
  fail-test 'no debug log output when there should be'
}

log-info test | grep test || {
  fail-test 'no info log output when there should be'
}

log-warn test | grep test || {
  fail-test 'no warning log output when there should be'
}

log-error test 2>&1 | grep test || {
  fail-test 'no error log output when there should be'
}

(log-fatal test || true) 2>&1 | grep test || {
  fail-test 'no fatal log output when there should be'
}

# NOTE: For the following EZLOG_LEVEL tests, we're counting bytes passed through
# the pipe and not using `grep`, because for some reason `grep` fails in BOTH
# positive and negative cases

### Debug is off
for level in "${EZLOG_LEVEL_INFO}" "${EZLOG_LEVEL_WARN}" "${EZLOG_LEVEL_ERROR}" "${EZLOG_LEVEL_FATAL}" ; do
  EZLOG_LEVEL="${level}"
  [[ "$(log-debug test | wc -c)" -eq 0 ]] || {
    EZLOG_LEVEL="${EZLOG_LEVEL_DEBUG}"
    fail-test "had debug log output at level ${level} and should not"
  }
done

### Info is off
for level in "${EZLOG_LEVEL_WARN}" "${EZLOG_LEVEL_ERROR}" "${EZLOG_LEVEL_FATAL}" ; do
  EZLOG_LEVEL="${level}"
  [[ "$(log-info test | wc -c)" -eq 0 ]] || {
    EZLOG_LEVEL="${EZLOG_LEVEL_DEBUG}"
    fail-test "had info log output at level ${level} and should not"
  }
done

### Warn is off
for level in "${EZLOG_LEVEL_ERROR}" "${EZLOG_LEVEL_FATAL}" ; do
  EZLOG_LEVEL="${level}"
  [[ "$(log-warn test | wc -c)" -eq 0 ]] || {
    EZLOG_LEVEL="${EZLOG_LEVEL_DEBUG}"
    fail-test "had warning log output at level ${level} and should not"
  }
done

### Error is off
EZLOG_LEVEL="${EZLOG_LEVEL_FATAL}"
[[ "$(log-error test 2>&1 | wc -c)" -eq 0 ]] || {
  EZLOG_LEVEL="${EZLOG_LEVEL_DEBUG}"
  fail-test "had error log output at level ${EZLOG_LEVEL_FATAL} and should not"
}

### All logs are off
EZLOG_LEVEL=0
[[ "$( (log-fatal test || true) 2>&1 | wc -c)" -eq 0 ]] || {
  EZLOG_LEVEL="${EZLOG_LEVEL_DEBUG}"
  fail-test "had fatal log output at level 0 and should not"
}

### A log level name also works
EZLOG_LEVEL=info
log-info test | grep -q test || {
  fail-test 'no info log output when EZLOG_LEVEL=info, and there should be'
}
[[ "$(log-debug test | wc -c)" -eq 0 ]] || {
  fail-test 'had debug log output when EZLOG_LEVEL=info, and should not'
}

# ### Test ANSI colors
# # TODO: find a way to actually test this because it's not working right now
# log-info test | grep --fixed "${INFO_COLOR}" || {
#   fail-test 'did not find ANSI color code and should have'
# }

### END
EZLOG_LEVEL="${EZLOG_LEVEL_DEBUG}"
check-failures
