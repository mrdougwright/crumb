defmodule Crumb.Validators.IdentityValidator do
  @moduledoc """
  Validate incoming `identify` events. Example payload (normalized before validation):
  ```
  {
    "userId": "abc123",
    "traits": {
      "email": "john@doe.com"
    }
  }
  """
  import Ecto.Changeset

  def validate(params) do
    types = %{
      user_id: :string,
      traits: :map,
      inserted_at: :utc_datetime
    }

    {%{}, types}
    |> cast(params, Map.keys(types))
    |> validate_required([:user_id])
    |> validate_length(:user_id, min: 1, max: 255)
    |> validate_change(:traits, fn :traits, val ->
      if is_map(val), do: [], else: [traits: "must be a map"]
    end)
  end
end
