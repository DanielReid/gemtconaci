chmod 0600 /root/.pgpass
psql -h postgres-postgresql -U postgres   -c "CREATE USER gemtc WITH PASSWORD 'develop'"   -c "CREATE DATABASE gemtc ENCODING 'utf-8' OWNER gemtc"
psql -h postgres-postgresql -U gemtc   -f /db-init.sql

psql -h postgres-postgresql -U postgres -c "CREATE USER patavi WITH PASSWORD 'develop'" -c "CREATE DATABASE patavi ENCODING 'utf-8' OWNER patavi"
psql -h postgres-postgresql -U patavi  -f /db-patavi.sql
