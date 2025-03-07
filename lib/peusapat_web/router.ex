defmodule PeusapatWeb.Router do
  use PeusapatWeb, :router

  import PeusapatWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PeusapatWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PeusapatWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/auth/github", PeusapatWeb do
    pipe_through :browser

    get "/", GithubAuthController, :request
    get "/callback", GithubAuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", PeusapatWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:peusapat, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PeusapatWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", PeusapatWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{PeusapatWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      # live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      # live "/users/reset_password", UserForgotPasswordLive, :new
      # live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    # post "/users/log_in", UserSessionController, :create
  end

  scope "/", PeusapatWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{PeusapatWeb.UserAuth, :ensure_authenticated}] do
      # live "/users/settings", UserSettingsLive, :edit
      # live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      scope "/admin", as: :admin do
        live "/communities", CommunityLive.Index, :index
        live "/communities/new", CommunityLive.Index, :new
        live "/communities/:id/edit", CommunityLive.Index, :edit

        live "/communities/:id", CommunityLive.Show, :show
        live "/communities/:id/show/edit", CommunityLive.Show, :edit

        # Temporary
        live "/topics", TopicLive.Index, :index
        live "/topics/new", TopicLive.Index, :new
        live "/topics/:id/edit", TopicLive.Index, :edit

        live "/topics/:id", TopicLive.Show, :show
        live "/topics/:id/show/edit", TopicLive.Show, :edit
      end

      live "/:community_slug/topics/:topic_id", CommunityLive.Reply
      live "/:community_slug/topics/:topic_id/delete", CommunityLive.Delete
      live "/:community_slug/replies/:reply_id/delete", ReplyLive.Delete

      live "/communities/new", CommunityLive.New
    end
  end

  scope "/", PeusapatWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{PeusapatWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
      live "/:community_slug", CommunityLive.Chat
    end
  end
end
