defmodule Crumb.ApiKey do
  @moduledoc """
  API Key is per project, to authenticate an incoming request to the Crumb server.
  You can generate a new API key using the `mix crumb.gen.api_key <my_project>` command.
  Tokens are not hashed for security, they are simply stored in your database.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "api_keys" do
    field :active, :boolean, default: false
    field :token, :string
    field :project, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(api_key, attrs) do
    api_key
    |> cast(attrs, [:token, :project, :active])
    |> validate_required([:token, :project, :active])
    |> unique_constraint(:token)
  end
end
