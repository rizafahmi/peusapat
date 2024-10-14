defmodule PeusapatWeb.PageController do
  use PeusapatWeb, :controller

  def home(conn, _params) do
    communities = Peusapat.Communities.list_communities()
    render(conn, :home, communities: communities)
  end
end
