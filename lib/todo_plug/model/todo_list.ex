defmodule TodoPlug.Model.TodoList do
  @derive {Poison.Encoder, only: [:entries]}
  defstruct auto_id: 1, entries: %{}

  use GenServer

  alias TodoPlug.Model.TodoList

  def init(_), do: {:ok, %TodoList{}}

  def start_link(_) do
    GenServer.start_link(TodoList, [], name: :todo_server)
  end

  def get_pid(), do: self()

  def add_entry(server_pid, entry) do
    GenServer.call(server_pid, {:add_entry, entry})
  end

  def update_entry(server_pid, entry_id, updater_fun) do
    GenServer.call(server_pid, {:update_entry, entry_id, updater_fun})
  end

  def entries(server_pid, date) do
    GenServer.call(server_pid, {:entries, date})
  end

  def delete_entry(server_pid, entry_id) do
    GenServer.call(server_pid, {:delete_entry, entry_id})
  end

  def handle_call({:add_entry, entry}, _, %TodoList{entries: entries, auto_id: auto_id} = state) do
    entry = Map.put(entry, :id, auto_id)
    new_entries = Map.put(entries, auto_id, entry)
    new_state = %TodoList{state | entries: new_entries, auto_id: auto_id + 1}

    {:reply, new_state, new_state}
  end

  def handle_call({:update_entry, entry_id, updater_fun}, _, %TodoList{entries: entries} = state) do
    case entries[entry_id] do
      nil -> state

      old_entry ->
        old_entry_id = old_entry.id
        new_entry = %{id: ^old_entry_id} = updater_fun.(old_entry)
        new_entries = Map.put(entries, new_entry.id, new_entry)
        %TodoList{state | entries: new_entries}
    end
  end

  def handle_call({:entries, date}, _, %TodoList{entries: entries} = state) do
    result = entries
    |> Stream.filter(fn({_, entry}) -> entry["date"] == date end)
    |> Enum.map(fn({_, entry}) -> entry end)

    {:reply, result, state}
  end

  def handle_call({:delete_entry, entry_id}, _, %TodoList{entries: entries} = state) do
    new_state = %TodoList{state | entries: Map.delete(entries, entry_id)}
    {new_state, new_state}
  end
end
