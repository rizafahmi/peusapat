defmodule PeusapatWeb.CommunityLive.ChatTest do
  use PeusapatWeb.ConnCase

  import Peusapat.{RepliesFixtures, UsersFixtures, TopicsFixtures}
  import Phoenix.LiveViewTest

  describe "Chat" do
    test "show count replies", %{conn: conn} do
      # create user
      other_user = user_fixture()
      # create topic
      topic = topic_fixture()
      dbg(topic)
      community = Peusapat.Communities.get_community!(topic.community_id)
      # go to chat page
      {:ok, live, _html} = live(conn, ~p"/#{community.slug}")
      # check for count replies
      assert render(live) =~ "Reply"

      # Make it 1 reply
      reply_fixture(%{topic_id: topic.id, user_id: other_user.id})
      # {:ok, live, _html} = live(conn, ~p"/#{community.slug}")
      assert render(live) =~ "Reply (1)"

      reply_fixture(%{topic_id: topic.id, user_id: other_user.id})
      assert render(live) =~ "Reply (2)"
    end
  end
end
