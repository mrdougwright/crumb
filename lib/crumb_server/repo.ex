defmodule CrumbServer.Repo do
  use Ecto.Repo,
    otp_app: :crumb_server,
    adapter: Ecto.Adapters.Postgres
end
