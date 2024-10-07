defmodule Peusapat.TopicsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Peusapat.Topics` context.
  """

  @doc """
  Generate a topic.
  """
  def topic_fixture(attrs \\ %{}) do
    {:ok, topic} =
      attrs
      |> Enum.into(%{
        post: "some post"
      })
      |> Peusapat.Topics.create_topic()

    topic
  end
end
