defmodule Crumb.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:event, :properties, :user_id, :inserted_at]}

  schema "events" do
    field :event, :string
    field :properties, :map
    field :user_id, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(event, attrs) do
    event
    |> cast(attrs, [:event, :user_id, :properties])
    |> validate_required([:event, :user_id])
  end
end
