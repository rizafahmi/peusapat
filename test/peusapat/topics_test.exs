defmodule Peusapat.TopicsTest do
  use Peusapat.DataCase

  alias Peusapat.Topics

  describe "topics" do
    alias Peusapat.Topics.Topic

    import Peusapat.TopicsFixtures
    import Peusapat.CommunitiesFixtures
    import Peusapat.UsersFixtures

    @invalid_attrs %{post: nil}

    test "list_topics/0 returns all topics" do
      topic = topic_fixture()
      assert Topics.list_topics() == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      assert Topics.get_topic!(topic.id) == topic
    end

    test "create_topic/1 with valid data creates a topic" do
      community = community_fixture()
      user = user_fixture()
      valid_attrs = %{post: "some post", community_id: community.id, user_id: user.id}

      assert {:ok, %Topic{} = topic} = Topics.create_topic(valid_attrs)
      assert topic.post == "some post"
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Topics.create_topic(@invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()
      update_attrs = %{post: "some updated post"}

      assert {:ok, %Topic{} = topic} = Topics.update_topic(topic, update_attrs)
      assert topic.post == "some updated post"
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Topics.update_topic(topic, @invalid_attrs)
      assert topic == Topics.get_topic!(topic.id)
    end

    test "delete_topic/1 deletes the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{}} = Topics.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Topics.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = topic_fixture()
      assert %Ecto.Changeset{} = Topics.change_topic(topic)
    end
  end
end
