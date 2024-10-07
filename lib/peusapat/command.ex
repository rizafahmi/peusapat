defmodule Peusapat.Command do
  @moduledoc """
  Command module for additional functions for every context
  """

  import Ecto.Query, warn: false
  alias Peusapat.Repo

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
        where: t.community_id == ^community.id,
        order_by: [desc: t.inserted_at],
        preload: [:user]

    Repo.all(query)
  end
end
