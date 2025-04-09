defmodule CrumbWeb.Plugs.AuthorizeApiKeyTest do
  use CrumbWeb.ConnCase, async: true

  alias Crumb.ApiKey
  alias CrumbWeb.Plugs.AuthorizeApiKey

  setup do
    key =
      Crumb.Repo.insert!(%ApiKey{
        token: "valid-token",
        project: "test-project",
        active: true
      })

    %{api_key: key}
  end

  test "allows request with valid API key", %{conn: conn, api_key: key} do
    conn =
      conn
      |> put_req_header("authorization", "Bearer #{key.token}")
      |> AuthorizeApiKey.call([])

    assert conn.status != 401
    assert conn.assigns.api_key.id == key.id
  end

  test "rejects request with invalid API key", %{conn: conn} do
    conn =
      conn
      |> put_req_header("authorization", "Bearer nope")
      |> AuthorizeApiKey.call([])

    assert conn.halted
    assert conn.status == 401
    assert conn.resp_body =~ "Invalid or missing API key"
  end

  test "rejects request with missing Authorization header", %{conn: conn} do
    conn = AuthorizeApiKey.call(conn, [])
    assert conn.halted
    assert conn.status == 401
    assert conn.resp_body =~ "Invalid or missing API key"
  end
end
