defmodule CrumbServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CrumbServerWeb.Telemetry,
      CrumbServer.Repo,
      {DNSCluster, query: Application.get_env(:crumb_server, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CrumbServer.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: CrumbServer.Finch},
      # Start a worker by calling: CrumbServer.Worker.start_link(arg)
      # {CrumbServer.Worker, arg},
      # Start to serve requests, typically the last entry
      CrumbServerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CrumbServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CrumbServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
