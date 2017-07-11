defmodule TodoPlug.Model.Todo do
  @derive {Poison.Encoder, except: [:__meta__]}
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias TodoPlug.Model.Todo
  alias TodoPlug.Repo.TodoRepo

  schema "todos" do
    field :date, :date
    field :title, :string

    timestamps()
  end

  @required_fields ~w(date title)a

  def insert(%{} = todo) do
    %Todo{}
    |> changeset(todo)
    |> TodoRepo.insert()
  end

  def find(date) do
    query = from todo in Todo,
    where: todo.date == ^date,
    select: %{id: todo.id, title: todo.title, date: todo.date}

    TodoRepo.all(query)
  end

  defp changeset(todo, params \\ :empty) do
    cast(todo, params, [:date, :title])
      |> validate_required(@required_fields)
  end
end
