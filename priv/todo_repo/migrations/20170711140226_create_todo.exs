defmodule TodoPlug.Repo.TodoRepo.Migrations.CreateTodo do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :date, :date
      add :title, :string, null: false

      timestamps()
    end

    create index(:todos, [:date], name: :idx_date)
  end
end
