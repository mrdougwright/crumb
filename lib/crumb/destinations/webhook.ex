defmodule Crumb.Destination.Webhook do
  @behaviour Crumb.Destination

  require Logger

  def enabled? do
    System.get_env("FORWARD_WEBHOOK_URL") != nil
  end

  def send_event(event) do
    url = System.get_env("FORWARD_WEBHOOK_URL")

    if url do
      headers = [{"Content-Type", "application/json"}]
      body = Jason.encode!(event)

      Logger.debug("📤 Sending to Webhook: #{url}")
      HTTPoison.post(url, body, headers)
      :ok
    else
      {:error, :no_url}
    end
  end
end
