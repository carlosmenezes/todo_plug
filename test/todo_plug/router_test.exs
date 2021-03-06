defmodule TodoPlug.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias TodoPlug.Router

  @opts Router.init([])

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TodoPlug.Repo.TodoRepo)
  end

  describe "POST /todos" do
    test "it creates a todo" do
      conn = conn(:post, "/todos", ~s({"date": "2017-07-13", "title": "Elixir Study Group"}))
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 201
      assert %{} = todo = Poison.decode!(conn.resp_body)

      assert todo["title"] == "Elixir Study Group"
      assert todo["date"] == "2017-07-13"
    end

    test "it returns bad request with invalid data" do
      conn = conn(:post, "/todos", ~s({"date": "2001-01-01"}))
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 400
      assert conn.resp_body == "Bad Request"
    end
  end

  describe "GET /todos" do
    test "it retrieves todos by date" do
      conn(:post, "/todos", ~s({"date": "2017-07-13", "title": "Elixir Study Group"}))
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)
      conn = conn(:get, "/todos/2017-07-13", "")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 200
      assert [%{} = todo | _] = Poison.decode!(conn.resp_body)

      assert todo["title"] == "Elixir Study Group"
      assert todo["date"] == "2017-07-13"
    end
  end

  describe "PUT /todos" do
    test "it updates a todo" do
      conn = conn(:post, "/todos", ~s({"date": "2017-07-13", "title": "Elixir Study Group"}))
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)
      todo_json = Poison.decode!(conn.resp_body)
      conn = conn(:put, "/todos/#{todo_json["id"]}", ~s({"date": "2017-07-21", "title": "Updated Elixir Study Group"}))
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 200
      assert %{} = todo = Poison.decode!(conn.resp_body)

      assert todo["title"] == "Updated Elixir Study Group"
      assert todo["date"] == "2017-07-21"
    end
  end

  describe "DELETE /todos" do
    test "it deletes a todo" do
      conn = conn(:post, "/todos", ~s({"date": "2017-07-13", "title": "Elixir Study Group"}))
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)
      todo_json = Poison.decode!(conn.resp_body)
      conn = conn(:delete, "/todos/#{todo_json["id"]}")
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 204
      assert conn.resp_body == "No Content"
    end
  end
end
