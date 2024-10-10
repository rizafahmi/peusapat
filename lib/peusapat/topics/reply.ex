defmodule Peusapat.Topics.Reply do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "replies" do
    field :text, :string
    belongs_to :topic, Peusapat.Topics.Topic

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(reply, attrs) do
    reply
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
