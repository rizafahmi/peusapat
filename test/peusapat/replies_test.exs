defmodule Peusapat.RepliesTest do
  use Peusapat.DataCase

  alias Peusapat.Commands
  alias Peusapat.Topics.Reply
  import Peusapat.UsersFixtures
  import Peusapat.TopicsFixtures

  describe "replies" do
    test "create_reply/1 with valid data creates a reply" do
      user = user_fixture()
      topic = topic_fixture()
      valid_attrs = %{text: "some reply", user_id: user.id, parent_id: topic.id}

      assert {:ok, %Reply{} = reply} = Commands.create_reply(valid_attrs)
      assert reply.text == "some reply"
    end

    test "list_replies/1 returns all replies" do
      topic = topic_fixture()

      {:ok, %Reply{} = reply} =
        Commands.create_reply(%{
          text: "some reply",
          user_id: topic.user_id,
          parent_id: topic.id
        })

      replies = Commands.list_replies(topic.id)
      assert Enum.count(replies) == 1
      assert hd(replies).id == reply.id
    end
  end
end
