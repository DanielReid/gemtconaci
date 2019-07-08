chmod 0600 /root/.pgpass
psql -h postgres -U gemtc   -f /db-init.sql
