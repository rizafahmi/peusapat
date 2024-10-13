defmodule PeusapatWeb.ReplyLiveTest do
  use PeusapatWeb.ConnCase

  import Phoenix.LiveViewTest
  import Peusapat.TopicsFixtures
  import Peusapat.UsersFixtures

  @create_attrs %{text: "some reply"}
  # @update_attrs %{post: "some updated post"}
  # @invalid_attrs %{post: nil}

  defp create_topic(_community) do
    topic = topic_fixture() |> topic_preload()
    %{topic: topic}
  end

  describe "Reply page" do
    setup [:create_topic]

    test "Reply form", %{conn: conn, topic: topic} do
      {:ok, live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/#{topic.community.slug}/topics/#{topic.id}")

      assert html =~ "Back"
      assert html =~ topic.post

      assert live |> form("#reply-form", reply: @create_attrs) |> render_submit()
    end
  end
end
