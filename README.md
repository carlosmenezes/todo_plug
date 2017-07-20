# TodoPlug

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/c236546900594b31ab2d3fb961d469f2)](https://www.codacy.com/app/pachecomenezes/todo_plug?utm_source=github.com&utm_medium=referral&utm_content=carlosmenezes/todo_plug&utm_campaign=badger)

A simple TODO api made with [Plug](https://github.com/elixir-lang/plug) and [Ecto](https://github.com/elixir-ecto/ecto).

## Instructions

This app runs on Docker so have both [Docker](https://www.docker.com/get-docker) and [Docker Compose](https://docs.docker.com/compose/install) installed.

- __build app:__ `docker-compose build`
- __create database:__ `docker-compose run --rm -e MIX_ENV=<dev test> web mix ecto.create`
- __run migrations:__ `docker-compose run --rm -e MIX_ENV=<dev test> web mix ecto.migrate`
- __run tests:__ `docker-compose run --rm web mix test`
- __run app:__ `docker-compose up`
