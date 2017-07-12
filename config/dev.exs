use Mix.Config

config :todo_plug, TodoPlug.Repo.TodoRepo,
  adapter: Ecto.Adapters.MySQL,
  database: "todo_plug",
  username: "root",
  password: "root",
  hostname: "mysql"
