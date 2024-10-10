defmodule Peusapat.Topics.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "topics" do
    field :post, :string
    field :parent_id, :binary_id
    belongs_to :user, Peusapat.Users.User
    belongs_to :community, Peusapat.Communities.Community
    has_many :reply, Peusapat.Topics.Reply

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:post, :parent_id, :user_id, :community_id])
    |> validate_required([:post, :user_id, :community_id])
  end
end
