#!/bin/sh
set -eu

: "${DB_HOST:=db}"
: "${DB_PORT:=5432}"
: "${DB_USER:=wuzapi}"
: "${DB_PASSWORD:=wuzapi}"
: "${DB_NAME:=wuzapi}"

export PGPASSWORD="${DB_PASSWORD}"

until pg_isready -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" >/dev/null 2>&1; do
  sleep 2
done

psql \
  -h "${DB_HOST}" \
  -p "${DB_PORT}" \
  -U "${DB_USER}" \
  -d "${DB_NAME}" \
  -c "TRUNCATE TABLE IF EXISTS message_history;"
