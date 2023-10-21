#!/usr/bin/env bats

source "./src/main.sh"

@test "all logs print when maximum log level is set" {
  LOG_LEVEL="${LOG_LEVEL_DEBUG}"
  local failures=0

  log-debug test | grep test || {
    printf 'no debug log output when there should be\n'
    failures=$((failures+1))
  }
  log-info test | grep test || {
    printf 'no info log output when there should be\n'
    failures=$((failures+1))
  }
  log-warn test | grep test || {
    printf 'no warning log output when there should be\n'
    failures=$((failures+1))
  }
  log-error test 2>&1 | grep test || {
    printf 'no error log output when there should be\n'
    failures=$((failures+1))
  }
  (log-fatal test || true) 2>&1 | grep test || {
    printf 'no fatal log output when there should be\n'
    failures=$((failures+1))
  }

  if [[ "${failures}" -gt 0 ]] ; then
    return 1
  fi
}

# NOTE: For the following LOG_LEVEL tests, we're counting bytes passed through
# the pipe and not using `grep`, because for some reason `grep` fails in BOTH
# positive and negative cases
@test "debug logs disabled at various higher levels" {
  local failures=0

  for level in \
    "${LOG_LEVEL_INFO}" \
    "${LOG_LEVEL_WARN}" \
    "${LOG_LEVEL_ERROR}" \
    "${LOG_LEVEL_FATAL}" \
  ; do
    LOG_LEVEL="${level}"
    [[ "$(log-debug test | wc -c)" -eq 0 ]] || {
      LOG_LEVEL="${LOG_LEVEL_DEBUG}"
      printf 'had debug log output at level %s and should not\n' "${level}"
      failures=$((failures+1))
    }
  done

  if [[ "${failures}" -gt 0 ]] ; then
    return 1
  fi
}

@test "info logs disabled at various higher levels" {
  local failures=0

  for level in \
    "${LOG_LEVEL_WARN}" \
    "${LOG_LEVEL_ERROR}" \
    "${LOG_LEVEL_FATAL}" \
  ; do
    LOG_LEVEL="${level}"
    [[ "$(log-info test | wc -c)" -eq 0 ]] || {
      LOG_LEVEL="${LOG_LEVEL_DEBUG}"
      printf 'had info log output at level %s and should not\n' "${level}"
      failures=$((failures+1))
    }
  done

  if [[ "${failures}" -gt 0 ]] ; then
    return 1
  fi
}

@test "warn logs disabled at various higher levels" {
  local failures=0

  for level in \
    "${LOG_LEVEL_ERROR}" \
    "${LOG_LEVEL_FATAL}" \
  ; do
    LOG_LEVEL="${level}"
    [[ "$(log-warn test | wc -c)" -eq 0 ]] || {
      LOG_LEVEL="${LOG_LEVEL_DEBUG}"
      printf 'had warn log output at level %s and should not\n' "${level}"
      failures=$((failures+1))
    }
  done

  if [[ "${failures}" -gt 0 ]] ; then
    return 1
  fi
}

@test "error logs disabled at various higher levels" {
  local failures=0

  for level in \
    ${LOG_LEVEL_FATAL} \
  ; do
    LOG_LEVEL="${level}"
    [[ "$(log-error test | wc -c)" -eq 0 ]] || {
      LOG_LEVEL="${LOG_LEVEL_DEBUG}"
      printf 'had error log output at level %s and should not\n' "${level}"
      failures=$((failures+1))
    }
  done

  if [[ "${failures}" -gt 0 ]] ; then
    return 1
  fi
}

@test "all logs can be disabled" {
  LOG_LEVEL=0
  [[ "$( (log-fatal test || true) 2>&1 | wc -c)" -eq 0 ]] || {
    LOG_LEVEL="${LOG_LEVEL_DEBUG}"
    printf 'had log output at level %s and should not\n' 0
    return 0
  }
}
