ARG POSTGRES_VERSION
FROM postgres:$POSTGRES_VERSION AS builder
ARG POSTGRES_VERSION
ARG PGTAP_VERSION
RUN apk add --no-cache build-base git perl wget unzip
RUN wget --no-verbose http://api.pgxn.org/dist/pgtap/$PGTAP_VERSION/pgtap-$PGTAP_VERSION.zip
RUN unzip pgtap-*.zip
WORKDIR pgtap-$PGTAP_VERSION
RUN make
RUN make install

ARG POSTGRES_VERSION
FROM postgres:$POSTGRES_VERSION
ARG POSTGRES_VERSION
ARG PGTAP_VERSION
ENV DEST /usr/local/share/postgresql/extension/
COPY --from=builder $DEST $DEST
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]
