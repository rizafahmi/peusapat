defmodule Peusapat.CommunitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Peusapat.Communities` context.
  """

  @doc """
  Generate a community.
  """
  def community_fixture(attrs \\ %{}) do
    user = Peusapat.UsersFixtures.user_fixture()
    params = Map.put(attrs, :user_id, user.id)

    {:ok, community} =
      params
      |> Enum.into(%{
        description: "some description",
        logo: "some logo",
        name: "some name",
        slug: "some-name"
      })
      |> Peusapat.Communities.create_community()

    community
  end
end
