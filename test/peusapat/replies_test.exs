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
  end
end
