FROM crystallang/crystal:latest

ADD . /src
WORKDIR /src
RUN crystal build --release ./src/file_server.cr

RUN ldd ./file_server | tr -s '[:blank:]' '\n' | grep '^/' | \
   xargs -I % sh -c 'mkdir -p $(dirname deps%); cp % deps%;'

FROM scratch
COPY --from=0 /src/deps /
COPY --from=0 /src/file_server /file_server

EXPOSE 80

ENTRYPOINT ["/file_server"]
