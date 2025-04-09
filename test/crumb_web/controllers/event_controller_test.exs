defmodule CrumbWeb.EventControllerTest do
  use CrumbWeb.ConnCase
  alias Crumb.Repo

  import Crumb.ApiKeyFixtures

  describe "track/1" do
    setup ctx do
      key = api_key_fixture()
      conn = put_req_header(ctx.conn, "authorization", "Bearer #{key.token}")
      %{conn: conn}
    end

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
