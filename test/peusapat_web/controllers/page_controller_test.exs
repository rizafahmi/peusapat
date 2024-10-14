defmodule PeusapatWeb.PageControllerTest do
  use PeusapatWeb.ConnCase

  import Peusapat.CommunitiesFixtures

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Community Discussion, Simplified"
  end

  setup do
    community = community_fixture()
    %{community: community}
  end

  test "GET / have list of communities", %{conn: conn, community: community} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ community.name
  end
end
