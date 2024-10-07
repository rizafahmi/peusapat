defmodule Peusapat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PeusapatWeb.Telemetry,
      Peusapat.Repo,
      {DNSCluster, query: Application.get_env(:peusapat, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Peusapat.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Peusapat.Finch},
      # Start a worker by calling: Peusapat.Worker.start_link(arg)
      # {Peusapat.Worker, arg},
      # Start to serve requests, typically the last entry
      PeusapatWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Peusapat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PeusapatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
