defmodule Crumb.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :event, :string
    field :user_id, :string
    field :properties, :map

    timestamps()
  end

  def changeset(event, attrs) do
    event
    |> cast(attrs, [:event, :user_id, :properties])
    |> validate_required([:event, :user_id])
  end
end
