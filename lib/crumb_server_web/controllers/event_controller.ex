defmodule CrumbServerWeb.EventController do
  use CrumbServerWeb, :controller

  def track(conn, %{
        "event" => event,
        "properties" => properties,
        "userId" => user_id
      }) do
    IO.inspect({event, properties, user_id}, label: "💾 Received event")

    json(conn, %{status: "ok"})
  end

  def track(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Missing required fields"})
  end
end
