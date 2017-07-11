defmodule TodoPlug.Router do
  use Plug.Router
  require Logger

  alias TodoPlug.Model.Todo

  plug :match
  plug Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison
  plug :dispatch

  post "/todos" do

    case Todo.insert(conn.params) do
      {:ok, todo} -> conn
        |> put_resp_content_type("application/json")
        |> send_resp(201, Poison.encode!(todo))
      {:error, _} -> send_resp(conn, 400, "Bad Request")
    end
  end

  get "/todos/:date" do
    
    result = Todo.find(date)
    conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Poison.encode!(result))
  end

  put "/todos/:date" do

  end

  match _, do: send_resp(conn, 404, "Not Found.")
end
