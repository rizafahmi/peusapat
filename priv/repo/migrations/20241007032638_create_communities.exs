defmodule Peusapat.Repo.Migrations.CreateCommunities do
  use Ecto.Migration

  def change do
    create table(:communities, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :logo, :string
      add :description, :text
      add :slug, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:communities, [:user_id])
  end
end
