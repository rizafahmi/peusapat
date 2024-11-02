defmodule Peusapat.RepliesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Peusapat.Replies` context.
  """
  import Ecto.Query, warn: false
  # alias Peusapat.Repo

  @doc """
  Generate a topic.
  """

  def reply_fixture(%{topic_id: topic_id, user_id: user_id} = attrs) do
    {:ok, reply} =
      attrs
      |> Enum.into(%{
        text: "some reply",
        parent_id: topic_id,
        user_id: user_id
      })
      |> Peusapat.Topics.create_reply()

    reply
  end
end
