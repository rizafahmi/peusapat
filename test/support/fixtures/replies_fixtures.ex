defmodule Peusapat.RepliesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Peusapat.Replies` context.
  """
  import Ecto.Query, warn: false
  alias Peusapat.Repo
  import Peusapat.UsersFixtures

  @doc """
  Generate a topic.
  """

  def reply_fixture(attrs \\ %{}) do
    user = user_fixture()

    params =
      attrs
      |> Map.put(:user_id, user.id)

    {:ok, reply} =
      params
      |> Enum.into(%{
        text: "some reply"
      })
      |> Peusapat.Topics.create_reply()

    reply
  end
end
