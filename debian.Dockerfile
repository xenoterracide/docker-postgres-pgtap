ARG PG_VERSION
FROM postgres:$PG_VERSION AS builder
ARG PGTAP_VERSION
RUN apt-get update
RUN apt-get install build-essential git perl wget unzip
RUN wget --no-verbose http://api.pgxn.org/dist/pgtap/$PGTAP_VERSION/pgtap-$PGTAP_VERSION.zip
RUN unzip pgtap-*.zip
WORKDIR pgtap-$PGTAP_VERSION
RUN make
RUN make install

FROM postgres:$PG_VERSION
ENV DEST /usr/local/share/postgresql/extension/
COPY --from=builder $DEST $DEST
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]
