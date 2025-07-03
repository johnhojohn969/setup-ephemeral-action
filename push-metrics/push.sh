#!/usr/bin/env bash
set -euo pipefail

value="${VALUE:?}"
metric_name="${METRIC_NAME:?}"
job="${JOB:-ci-default}"
url="${PUSHGATEWAY_URL:-http://pushgateway:9091}"

cat <<METRIC | curl --fail --data-binary @- "$url/metrics/job/$job"
${metric_name} ${value}
METRIC
