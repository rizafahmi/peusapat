defmodule Peusapat.Repo.Migrations.CreateTopics do
  use Ecto.Migration

  def change do
    create table(:topics, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :post, :text
      add :parent_id, references(:topics, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :community_id, references(:communities, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:topics, [:parent_id])
    create index(:topics, [:user_id])
    create index(:topics, [:community_id])
  end
end
