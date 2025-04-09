defmodule CrumbWeb.Plugs.AuthorizeApiKey do
  import Plug.Conn
  alias Crumb.Repo
  alias Crumb.ApiKey

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        case Repo.get_by(ApiKey, token: token, active: true) do
          nil ->
            reject(conn)

          api_key ->
            assign(conn, :api_key, api_key)
        end

      _ ->
        reject(conn)
    end
  end

  defp reject(conn) do
    conn
    |> send_resp(:unauthorized, ~s({"error": "Invalid or missing API key"}))
    |> halt()
  end
end
