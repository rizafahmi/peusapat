defmodule Peusapat.CommunitiesTest do
  use Peusapat.DataCase

  alias Peusapat.Communities

  describe "communities" do
    alias Peusapat.Communities.Community

    import Peusapat.CommunitiesFixtures
    import Peusapat.UsersFixtures

    @invalid_attrs %{description: nil, logo: nil, name: nil, slug: nil}

    test "list_communities/0 returns all communities" do
      community = community_fixture()
      assert Communities.list_communities() == [community]
    end

    test "get_community!/1 returns the community with given id" do
      community = community_fixture()
      assert Communities.get_community!(community.id) == community
    end

    test "create_community/1 with valid data creates a community" do
      user = user_fixture()

      valid_attrs = %{
        description: "some description",
        logo: "some logo",
        name: "some name",
        slug: "some slug",
        user_id: user.id
      }

      assert {:ok, %Community{} = community} = Communities.create_community(valid_attrs)
      assert community.description == "some description"
      assert community.logo == "some logo"
      assert community.name == "some name"
      assert community.slug == "some slug"
    end

    test "create_community/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Communities.create_community(@invalid_attrs)
    end

    test "update_community/2 with valid data updates the community" do
      community = community_fixture()

      update_attrs = %{
        description: "some updated description",
        logo: "some updated logo",
        name: "some updated name",
        slug: "some updated slug"
      }

      assert {:ok, %Community{} = community} =
               Communities.update_community(community, update_attrs)

      assert community.description == "some updated description"
      assert community.logo == "some updated logo"
      assert community.name == "some updated name"
      assert community.slug == "some updated slug"
    end

    test "update_community/2 with invalid data returns error changeset" do
      community = community_fixture()
      assert {:error, %Ecto.Changeset{}} = Communities.update_community(community, @invalid_attrs)
      assert community == Communities.get_community!(community.id)
    end

    test "delete_community/1 deletes the community" do
      community = community_fixture()
      assert {:ok, %Community{}} = Communities.delete_community(community)
      assert_raise Ecto.NoResultsError, fn -> Communities.get_community!(community.id) end
    end

    test "change_community/1 returns a community changeset" do
      community = community_fixture()
      assert %Ecto.Changeset{} = Communities.change_community(community)
    end
  end
end
