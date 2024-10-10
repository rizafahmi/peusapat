defmodule Peusapat.Repo.Migrations.CreateReplies do
  use Ecto.Migration

  def change do
    create table(:replies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :text, :text
      add :parent_id, references(:topics, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:replies, [:parent_id])
  end
end
