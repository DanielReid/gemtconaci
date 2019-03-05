FROM postgres
COPY db/pgpass /root/.pgpass
COPY db/db.sh /
COPY db/db-init.sql /
COPY db/db-patavi.sql /

CMD ["/db.sh"]