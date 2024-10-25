defmodule PeusapatWeb.GithubAuth do
  import Plug.Conn

  alias Assent.{Config, Strategy.Github}
  alias PeusapatWeb.UserAuth
  alias Peusapat.Users
  alias Peusapat.Users.User

  def request(conn) do
    Application.get_env(:assent, :github)
    |> Github.authorize_url()
    |> case do
      {:ok, %{url: url, session_params: session_params}} ->
        conn
        |> put_session(:session_params, session_params)
        |> put_resp_header("location", url)
        |> send_resp(302, "")

      {:error, reason} ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(
          500,
          "Something went wrong generating request authorization url: #{inspect(reason)}"
        )
    end
  end

  def callback(conn) do
    %{params: params} = fetch_query_params(conn)
    session_params = get_session(conn, :session_params)

    Application.get_env(:assent, :github)
    |> Config.put(:session_params, session_params)
    |> Github.callback(params)
    |> case do
      {:ok, %{user: user, token: token}} ->
        user = Users.get_user_by_email_or_register(user["email"])

        conn
        |> UserAuth.log_in_user(user)
        |> put_session(:github_user, user)
        |> put_session(:github_user_token, token)
        |> Phoenix.Controller.redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(500, inspect(reason, pretty: true))
    end
  end

  def fetch_github_user(conn, _opts) do
    with user when is_map(user) <- get_session(conn, :github_user) do
      assign(conn, :current_user, %User{email: user["email"]})
    else
      _ -> conn
    end
  end

  def on_mount(:mount_current_user, _params, session, socket) do
    {:cont, mount_current_user(socket, session)}
  end

  defp mount_current_user(socket, session) do
    Phoenix.Component.assign_new(socket, :current_user, fn ->
      if(user = session["github_user"]) do
        %User{email: user["email"]}
      end
    end)
  end
end
