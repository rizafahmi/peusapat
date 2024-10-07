defmodule Peusapat.CommunitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Peusapat.Communities` context.
  """

  @doc """
  Generate a community.
  """
  def community_fixture(attrs \\ %{}) do
    {:ok, community} =
      attrs
      |> Enum.into(%{
        description: "some description",
        logo: "some logo",
        name: "some name",
        slug: "some slug"
      })
      |> Peusapat.Communities.create_community()

    community
  end
end
