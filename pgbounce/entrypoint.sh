#!/bin/bash
set -e

# ${DB_NAME:-evolution} = host=${DB_HOST} port=${DB_PORT:-5432} user=${DB_USER} password=${DB_PASSWORD} dbname=${DB_NAME:-evolution}

# Create pgbouncer config from environment variables
cat > /etc/pgbouncer/pgbouncer.ini << EOF
[databases]
${DB_NAME:-evolution} = host=${DB_HOST} port=${DB_PORT:-5432} user=${DB_USER} password=${DB_PASSWORD} dbname=${DB_NAME:-evolution}


[pgbouncer]
listen_addr = 0.0.0.0
listen_port = 6432
auth_type = md5
auth_file = /etc/pgbouncer/userlist.txt
logfile = /var/log/pgbouncer/pgbouncer.log
pidfile = /var/run/pgbouncer/pgbouncer.pid
admin_users = ${DB_USER}
stats_users = ${DB_USER}
pool_mode = ${POOL_MODE:-transaction}
max_client_conn = ${MAX_CLIENT_CONN:-1000}
default_pool_size = ${DEFAULT_POOL_SIZE:-20}
reserve_pool_size = ${RESERVE_POOL_SIZE:-10}
reserve_pool_timeout = ${RESERVE_POOL_TIMEOUT:-5}
server_reset_query = DISCARD ALL
server_check_delay = 30
server_check_query = select 1
server_lifetime = 3600
server_idle_timeout = 600
verbose = 1
EOF

# Create authentication file
cat > /etc/pgbouncer/userlist.txt << EOF
"${DB_USER}" "${DB_PASSWORD}"
EOF

# Run pgbouncer
exec pgbouncer /etc/pgbouncer/pgbouncer.ini