defmodule Crumb.Validator do
  @moduledoc """
  Dispatch to the appropriate validator based on the type of data being validated.
  """
  alias Crumb.Validators.EventValidator
  alias Crumb.Validators.IdentityValidator
  alias Crumb.Utils.Time

  def validate(params) do
    params = normalize(params)

    module =
      case params do
        %{event: _} -> EventValidator
        %{traits: _} -> IdentityValidator
      end

    case module.validate(params) do
      %{valid?: true, changes: clean_params} -> {:ok, clean_params}
      %{valid?: false} = changeset -> {:error, changeset}
    end
  end

  defp normalize(%{"event" => _} = params) do
    %{
      event: Map.get(params, "event"),
      properties: Map.get(params, "properties", %{}),
      user_id: Map.get(params, "user_id") || Map.get(params, "userId"),
      inserted_at: params |> Map.get("timestamp") |> Time.parse_str()
    }
  end

  defp normalize(params) do
    %{
      traits: Map.get(params, "traits", %{}),
      user_id: Map.get(params, "user_id") || Map.get(params, "userId"),
      inserted_at: params |> Map.get("timestamp") |> Time.parse_str()
    }
  end
end
