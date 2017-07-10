defmodule TodoPlug.Router do
  use Plug.Router
  require Logger

  alias TodoPlug.Model.TodoList

  plug :match
  plug Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison
  plug :dispatch

  post "/todos" do
    result = :todo_server
      |> TodoList.add_entry(conn.params)
      |> Poison.encode!

    conn
      |> put_resp_content_type("application/json")
      |> send_resp(201, result)
  end

  match _, do: send_resp(conn, 404, "Not Found.")
end
