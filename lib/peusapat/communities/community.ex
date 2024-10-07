defmodule Peusapat.Communities.Community do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "communities" do
    field :description, :string
    field :logo, :string
    field :name, :string
    field :slug, :string
    belongs_to :user, Peusapat.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(community, attrs) do
    community
    |> cast(attrs, [:name, :logo, :description, :slug, :user_id])
    |> validate_required([:name, :slug, :user_id])
  end
end
