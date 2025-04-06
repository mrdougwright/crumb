defmodule CrumbWeb.EventController do
  use CrumbWeb, :controller

  alias Crumb.Events.Event
  alias Crumb.Repo
  alias CrumbWeb.Validators.EventValidator

  def track(conn, %{"event" => _, "properties" => _, "userId" => _} = params) do
    map = params |> normalize_params() |> EventValidator.validate()

    with %{valid?: true, changes: clean_params} <- map,
         changeset <- Event.changeset(%Event{}, clean_params),
         {:ok, event} <- Repo.insert(changeset) do
      Crumb.Queue.enqueue(event)
      json(conn, %{status: "ok"})
    else
      %{valid?: false} = changeset -> validation_error(conn, changeset)
      {:error, changeset} -> insert_error(conn, changeset)
    end
  end

  def track(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Missing required fields"})
  end

  defp validation_error(conn, changeset) do
    conn
    |> put_status(:bad_request)
    |> json(%{
      error: "Validation failed",
      details: changeset.errors
    })
  end

  defp insert_error(conn, changeset) do
    IO.inspect(changeset.errors, label: "❌ Insertion failed")

    conn
    |> put_status(:bad_request)
    |> json(%{error: "Invalid event data"})
  end

  defp normalize_params(params) do
    %{
      event: Map.get(params, "event"),
      user_id: Map.get(params, "user_id") || Map.get(params, "userId"),
      properties: Map.get(params, "properties", %{})
    }
  end
end
