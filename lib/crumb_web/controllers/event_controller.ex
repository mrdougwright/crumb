defmodule CrumbWeb.EventController do
  use CrumbWeb, :controller

  alias Crumb.Events
  plug CrumbWeb.Plugs.AuthorizeApiKey

  def track(conn, params) do
    result =
      params
      |> Events.validate()
      |> Events.insert()
      |> Events.enqueue()

    case result do
      {:ok, event} ->
        json(conn, %{status: "ok", id: event.id})

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid event", details: changeset.errors})
    end
  end
end
