defmodule Peusapat.RepliesTest do
  use Peusapat.DataCase

  alias Peusapat.Commands
  alias Peusapat.Topics.Reply

  describe "replies" do
    test "create_reply/1 with valid data creates a reply" do
      valid_attrs = %{text: "some reply"}

      assert {:ok, %Reply{} = topic} = Commands.create_reply(valid_attrs)
      assert topic.text == "some reply"
    end
  end
end
