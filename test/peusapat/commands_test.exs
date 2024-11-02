defmodule Peusapat.CommandsTest do
  use Peusapat.DataCase

  alias Peusapat.Commands

  describe "topics" do
    # alias Peusapat.Topics.Topic

    import Peusapat.{TopicsFixtures, RepliesFixtures}

    # @invalid_attrs %{post: nil}

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      topic_preload = topic_preload(topic)
      assert Commands.get_topic_preload!(topic.id) == topic_preload
    end
  end
end
