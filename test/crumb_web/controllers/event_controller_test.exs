defmodule CrumbWeb.EventControllerTest do
  use CrumbWeb.ConnCase
  alias Crumb.Repo

  describe "track/1" do
    test "POST /api/track stores valid event", %{conn: conn} do
      payload = %{
        "event" => "Test Event",
        "userId" => "abc123",
        "properties" => %{"foo" => "bar"}
      }

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/track", Jason.encode!(payload))

      assert json_response(conn, 200)["status"] == "ok"
      assert Repo.aggregate(Crumb.Events.Event, :count, :id) == 1
    end
  end
end
