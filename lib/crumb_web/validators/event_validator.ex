defmodule CrumbWeb.Validators.EventValidator do
  @moduledoc """
  Validate incoming events. Example payload (normalized before validation):
  ```
  {
    "event": "Signup Completed",
    "userId": "abc123",
    "properties": {
      "plan": "pro"
    }
  }
  """
  import Ecto.Changeset

  def validate(params) do
    types = %{
      event: :string,
      user_id: :string,
      properties: :map,
      inserted_at: :utc_datetime
    }

    {%{}, types}
    |> cast(params, Map.keys(types))
    |> validate_required([:event, :user_id])
    |> validate_length(:event, min: 1, max: 255)
    |> validate_length(:user_id, min: 1, max: 255)
    |> validate_change(:properties, fn :properties, val ->
      if is_map(val), do: [], else: [properties: "must be a map"]
    end)
  end
end
