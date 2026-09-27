#!/usr/bin/env bash
# =============================================================================
#  run_all.sh  -  run one stage for ALL seven of your systems, one after another.
#
#  Usage:  bash scripts/run_all.sh 1          # full Stage 1 for all seven
#          bash scripts/run_all.sh 1 --quick  # ten-minute test on all seven
#
#  Use this only AFTER a --quick test has passed on one system. It is meant for
#  leaving running overnight. If one system fails the others still run, and a
#  summary of what worked is printed at the end.
# =============================================================================
set -uo pipefail
STAGE="${1:-}"
QUICK="${2:-}"
case "$STAGE" in 1|2|3) ;; *) echo "Usage: bash scripts/run_all.sh <1|2|3> [--quick]"; exit 1;; esac

HERE="$(cd "$(dirname "$0")/.." && pwd)"
cd "$HERE"
mkdir -p results/logs
PASS=(); FAIL=()

for S in $(ls systems); do
    echo
    echo "############################################################"
    echo "# $S   (stage $STAGE)   started $(date '+%H:%M:%S')"
    echo "############################################################"
    LOG="results/logs/${S}_stage${STAGE}.log"
    if bash "scripts/run_stage${STAGE}.sh" "$S" ${QUICK:+--quick} > "$LOG" 2>&1; then
        PASS+=("$S"); echo "  finished. log: $LOG"
        grep -A4 "First-shell structure" "$LOG" | tail -3 || true
    else
        FAIL+=("$S"); echo "  FAILED. last 15 lines of $LOG:"; tail -15 "$LOG"
    fi
done

echo
echo "############################################################"
echo "# stage $STAGE summary"
echo "############################################################"
printf '  finished: %s\n' "${PASS[@]:-none}"
printf '  FAILED  : %s\n' "${FAIL[@]:-none}"
echo "  full logs are in results/logs/"
