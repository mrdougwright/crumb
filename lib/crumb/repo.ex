defmodule Crumb.Repo do
  use Ecto.Repo,
    otp_app: :crumb,
    adapter: Ecto.Adapters.Postgres
end
