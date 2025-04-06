defmodule Crumb.Events do
  @moduledoc """
  Context for Event logic
  """

  alias Crumb.Events.Event
  alias Crumb.Repo
  alias Crumb.Utils.Time
  alias CrumbWeb.Validators.EventValidator
  require Logger

  def validate(params) do
    params = normalize_params(params)

    case EventValidator.validate(params) do
      %{valid?: true, changes: clean_params} -> {:ok, clean_params}
      %{valid?: false} = changeset -> {:error, changeset}
    end
  end

  def insert({:ok, clean_params}) do
    changeset = Event.changeset(%Event{}, clean_params)

    case Repo.insert(changeset) do
      {:ok, event} -> {:ok, event}
      {:error, cs} -> {:error, cs}
    end
  end

  def insert({:error, _} = err), do: err

  def enqueue({:ok, event}) do
    Crumb.Queue.enqueue(event)
    {:ok, event}
  end

  def enqueue({:error, _} = err), do: err

  defp normalize_params(params) do
    %{
      event: Map.get(params, "event"),
      user_id: Map.get(params, "user_id") || Map.get(params, "userId"),
      properties: Map.get(params, "properties", %{}),
      inserted_at: params |> Map.get("timestamp") |> Time.parse_str()
    }
  end
end
