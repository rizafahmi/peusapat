defmodule PeusapatWeb.GithubAuthController do
  use PeusapatWeb, :controller
  alias PeusapatWeb.GithubAuth

  def request(conn, _params) do
    GithubAuth.request(conn)
  end

  def callback(conn, _params) do
    GithubAuth.callback(conn)
  end
end
