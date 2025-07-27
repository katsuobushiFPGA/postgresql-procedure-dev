FROM postgres:17

RUN apt-get update && \
    apt-get install -y git make gcc libkrb5-dev postgresql-server-dev-17 curl

WORKDIR /tmp
RUN git clone https://github.com/EnterpriseDB/pldebugger

WORKDIR /tmp/pldebugger
# USE_PGXS=1 をつけること既存のPostgreSQLへの拡張インストールができる
RUN USE_PGXS=1 make 
RUN USE_PGXS=1 make install

# pg_proveのインストール
RUN curl -LO http://xrl.us/cpanm \
    && chmod +x cpanm \
    && ./cpanm TAP::Parser::SourceHandler::pgTAP

# pgTAPのインストール
WORKDIR /tmp
RUN git clone https://github.com/theory/pgtap.git

WORKDIR /tmp/pgtap
RUN make
RUN make install

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]