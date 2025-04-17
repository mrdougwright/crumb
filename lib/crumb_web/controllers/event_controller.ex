defmodule CrumbWeb.EventController do
  use CrumbWeb, :controller

  alias Crumb.Events
  alias Crumb.Validator

  def track(conn, params) do
    result =
      params
      |> Validator.validate()
      |> Events.insert()
      |> Events.enqueue(:event)

    case result do
      {:ok, event} ->
        json(conn, %{status: "ok", id: event.id})

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid event", details: changeset.errors})
    end
  end

  def identify(conn, params) do
    result =
      params
      |> Validator.validate()
      |> Events.enqueue(:identify)

    case result do
      {:ok, _idf} ->
        json(conn, %{status: "ok"})

      {:error, :invalid_payload} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid identify payload"})
    end
  end
end
