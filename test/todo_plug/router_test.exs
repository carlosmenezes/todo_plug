defmodule TodoPlug.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias TodoPlug.Router

  @opts Router.init([])

  setup do
    TodoPlug.Model.TodoList.start_link([])

    on_exit fn ->
      if GenServer.whereis(:todo_server), do: GenServer.stop(:todo_server)
    end
  end

  test "it creates a todo" do
    conn = conn(:post, "/todos", ~s({"date": "2017-07-13", "title": "Elixir Study Group"}))
      |> put_req_header("content-type", "application/json")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 201
    assert %{"entries" => %{"1" => entry}} = Poison.decode!(conn.resp_body)
    IO.inspect(Poison.decode!(conn.resp_body), label: "Result First Test")

    assert entry["id"] == 1
    assert entry["title"] == "Elixir Study Group"
    assert entry["date"] == "2017-07-13"
  end

  test "it retains state between requests" do
    conn(:post, "/todos", ~s({"date": "2017-07-13", "title": "Elixir Study Group"}))
      |> put_req_header("content-type", "application/json")
      |> Router.call(@opts)
    conn = conn(:post, "/todos", ~s({"date": "2017-07-15", "title": "Another TODO"}))
      |> put_req_header("content-type", "application/json")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 201
    assert %{"entries" => %{"1" => entry, "2" => entry2}} = Poison.decode!(conn.resp_body)

    assert entry["id"] == 1
    assert entry["title"] == "Elixir Study Group"
    assert entry["date"] == "2017-07-13"

    assert entry2["id"] == 2
    assert entry2["title"] == "Another TODO"
    assert entry2["date"] == "2017-07-15"
  end
end
