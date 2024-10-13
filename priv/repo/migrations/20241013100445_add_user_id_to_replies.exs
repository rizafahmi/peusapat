defmodule Peusapat.Repo.Migrations.AddUserIdToReplies do
  use Ecto.Migration

  def change do
    alter table(:replies) do
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
    end
  end
end
