defmodule Peusapat.Commands do
  @moduledoc """
  Command module for additional functions for every context
  """

  import Ecto.Query, warn: false
  alias Peusapat.Repo
  alias Peusapat.Topics.Reply

  @doc """
  Returns the list of communities by user_id.

  ## Examples

      iex> list_communities_by_user(123)
      [%Community{}, ...]

  """
  def list_communities_by_user(user_id) do
    query =
      from c in Peusapat.Communities.Community,
        where: c.user_id == ^user_id,
        order_by: [desc: c.inserted_at]

    Repo.all(query)
  end

  @doc """
  Return the community by slug.

  ## Examples

      iex> get_community_by_slug("test")
      %Community{}

  """
  def get_community_by_slug(slug) do
    query =
      from c in Peusapat.Communities.Community,
        where: c.slug == ^slug

    Repo.one(query)
  end

  @doc """
  Return the list of topics by community_slug.

  ## Examples

      iex> list_topics_by_community("test")
      [%Topic{}, ...]
  """
  def list_topics_by_community(community_slug) do
    community = get_community_by_slug(community_slug)

    query =
      from t in Peusapat.Topics.Topic,
        where: t.community_id == ^community.id and is_nil(t.parent_id),
        order_by: [desc: t.inserted_at],
        preload: [:user]

    Repo.all(query)
  end

  def get_topic_preload!(id) do
    query = from t in Peusapat.Topics.Topic, where: t.id == ^id, preload: [:user]

    Repo.one(query)
  end

  @doc """
  Creates a reply.
  ## Examples

      iex> create_reply(%{field: value})
      {:ok, %Reply{}}

      iex> create_reply(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reply(attrs \\ %{}) do
    %Reply{}
    |> Reply.changeset(attrs)
    |> Repo.insert()
  end
end
