defmodule Crumb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CrumbWeb.Telemetry,
      Crumb.Repo,
      {DNSCluster, query: Application.get_env(:crumb, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Crumb.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Crumb.Finch},
      # Start a worker by calling: Crumb.Worker.start_link(arg)
      # {Crumb.Worker, arg},
      # Start to serve requests, typically the last entry
      CrumbWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Crumb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CrumbWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
