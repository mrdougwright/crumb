defmodule Crumb.ApiKey do
  @moduledoc """
  API Key is for end users of the system, per project, to authenticate
  an incoming request to the Crumb server. It should be:
  🔒 Write-only: can only send events
  🔒 Project-scoped: key only belongs to one project
  ✅ Safe to expose publicly in the browser
  🚫 No read, update, or admin powers
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
