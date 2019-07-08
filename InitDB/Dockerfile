FROM postgres
COPY db/pgpass /root/.pgpass
COPY db/db.sh /
COPY db/db-init.sql /

CMD ["/db.sh"]