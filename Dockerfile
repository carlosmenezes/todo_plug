FROM elixir:1.4.5-slim

RUN mkdir /todo_plug
WORKDIR /todo_plug
COPY mix.exs /todo_plug/mix.exs
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends mysql-client libmysqlclient-dev && \
    mix local.hex --force && \
    mix deps.get && \
    rm -rf /var/lib/apt/lists/*

COPY . /todo_plug

CMD mix run --no-halt
