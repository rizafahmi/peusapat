defmodule Peusapat.RepliesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Peusapat.Topics` context.
  """
  import Ecto.Query, warn: false

  @doc """
  Generate a topic.
  """

  def reply_fixture(attrs \\ %{}) do
    community = Peusapat.CommunitiesFixtures.community_fixture()
    topic = Peusapat.TopicsFixtures.topic_fixture(%{"community_id" => community.id})

    params =
      attrs
      |> Map.put(:topic_id, topic.id)
      |> Map.put(:user_id, community.user_id)

    {:ok, reply} =
      params
      |> Enum.into(%{
        post: "some post"
      })
      |> Peusapat.Topics.create_reply()

    dbg(reply)

    reply
  end

  # def topic_preload(topic) do
  #   query =
  #     from t in Peusapat.Topics.Topic, where: t.id == ^topic.id, preload: [:user, :community]

  #   Repo.one(query)
  # end
end
