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
    result = Todo.find_by_date(date)
    conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Poison.encode!(result))
  end

  put "/todos/:id" do
    case Todo.find(id) do
      nil -> send_resp(conn, 404, "Not Found")
      todo ->
        case Todo.update(todo, conn.params) do
          {:ok, result} -> conn
            |> put_resp_content_type("application/json")
            |> send_resp(200, Poison.encode!(result))
          {:error, _} -> send_resp(conn, 400, "Bad Request")
        end
    end
  end

  delete "/todos/:id" do
    case Todo.find(id) do
      nil -> send_resp(conn, 404, "Not Found")
      todo ->
        case Todo.delete(todo) do
          {:ok, _} -> send_resp(conn, 204, "No Content")
          {:error, _} -> send_resp(conn, 400, "Bad Request")
        end
    end
  end

  match _, do: send_resp(conn, 404, "Not Found.")
end
