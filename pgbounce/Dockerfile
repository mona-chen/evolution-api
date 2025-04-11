FROM ubuntu:22.04

RUN apt-get update && apt-get install -y pgbouncer postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Create required directories
RUN mkdir -p /etc/pgbouncer /var/log/pgbouncer /var/run/pgbouncer
RUN chown -R postgres:postgres /etc/pgbouncer /var/log/pgbouncer /var/run/pgbouncer

# Set up the entry point script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER postgres
EXPOSE 6432

ENTRYPOINT ["/entrypoint.sh"]