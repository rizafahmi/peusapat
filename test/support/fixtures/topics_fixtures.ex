defmodule Peusapat.TopicsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Peusapat.Topics` context.
  """
  import Ecto.Query, warn: false
  alias Peusapat.Repo

  @doc """
  Generate a topic.
  """

  def topic_fixture(attrs \\ %{}) do
    community = Peusapat.CommunitiesFixtures.community_fixture()

    params =
      attrs
      |> Map.put(:community_id, community.id)
      |> Map.put(:user_id, community.user_id)

    {:ok, topic} =
      params
      |> Enum.into(%{
        post: "some post"
      })
      |> Peusapat.Topics.create_topic()

    topic
  end

  def topic_preload(topic) do
    query = from t in Peusapat.Topics.Topic, where: t.id == ^topic.id, preload: [:user]

    Repo.one(query)
  end
end
