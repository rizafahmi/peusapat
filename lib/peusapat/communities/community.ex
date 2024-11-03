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
  def changeset(community, attrs \\ %{}) do
    community
    |> cast(attrs, [:name, :logo, :description, :user_id])
    |> generate_slug()
    |> validate_required([:name, :slug, :user_id])
  end

  defp generate_slug(changeset) do
    case get_change(changeset, :name) do
      nil -> changeset
      name -> put_change(changeset, :slug, String.downcase(name) |> String.replace(~r/\s+/, "-"))
    end
  end
end
