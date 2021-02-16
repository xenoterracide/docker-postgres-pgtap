FROM postgres:alpine AS builder
ENV PGTAP_VERSION '1.1.0'
RUN apk add --no-cache build-base git perl wget unzip
RUN wget --no-verbose http://api.pgxn.org/dist/pgtap/$PGTAP_VERSION/pgtap-$PGTAP_VERSION.zip
RUN unzip pgtap-*.zip
WORKDIR pgtap-$PGTAP_VERSION
RUN make
RUN make install

FROM postgres:alpine
ENV DEST /usr/local/share/postgresql/extension/
COPY --from=builder $DEST $DEST
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]
