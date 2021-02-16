ARG POSTGRES_VERSON
FROM postgres:$POSTGRES_VERSON AS builder
ARG PGTAP_VERSION
RUN apt-get update
RUN apt-get -y install build-essential git perl wget unzip
RUN wget --no-verbose http://api.pgxn.org/dist/pgtap/$PGTAP_VERSION/pgtap-$PGTAP_VERSION.zip
RUN unzip pgtap-*.zip
WORKDIR pgtap-$PGTAP_VERSION
RUN make
RUN make install

FROM postgres:$POSTGRES_VERSON
ENV DEST /usr/share/postgresql/$POSTGRES_VERSON/extension
COPY --from=builder $DEST $DEST
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]
