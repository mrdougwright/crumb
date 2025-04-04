defmodule CrumbWeb.EventController do
  use CrumbWeb, :controller

  alias Crumb.Events.Event
  alias Crumb.Repo

  def track(conn, %{"event" => event, "properties" => props, "userId" => user_id}) do
    changeset =
      Event.changeset(%Event{}, %{
        event: event,
        properties: props,
        user_id: user_id
      })

    case Repo.insert(changeset) do
      {:ok, _event} ->
        json(conn, %{status: "ok"})

      {:error, changeset} ->
        IO.inspect(changeset.errors, label: "❌ Insertion failed")

        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid event data"})
    end
  end

  def track(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Missing required fields"})
  end
end
