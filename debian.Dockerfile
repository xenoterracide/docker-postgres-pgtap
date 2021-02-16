ARG POSTGRES_VERSION
FROM postgres:$POSTGRES_VERSION AS builder
ARG PGTAP_VERSION
RUN apt-get update
RUN apt-get -y install build-essential git perl wget unzip
RUN wget --no-verbose http://api.pgxn.org/dist/pgtap/$PGTAP_VERSION/pgtap-$PGTAP_VERSION.zip
RUN unzip pgtap-*.zip
WORKDIR pgtap-$PGTAP_VERSION
RUN make
RUN make install

FROM postgres:$POSTGRES_VERSION
ENV PG_SHORT_VERSION=$(psql -V | awk -F '{ print $0 "." $1 }')
ENV DEST /usr/share/postgresql/$PG_SHORT_VERSION/extension
COPY --from=builder $DEST $DEST
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]
