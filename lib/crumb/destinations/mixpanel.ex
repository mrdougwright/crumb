defmodule Crumb.Destination.Mixpanel do
  @behaviour Crumb.Destination
  require Logger

  def enabled?, do: System.get_env("MIXPANEL_TOKEN") != nil

  def send_event(%{event: event, properties: props, user_id: user_id}) do
    token = System.get_env("MIXPANEL_TOKEN")

    payload = %{
      event: event,
      properties: Map.merge(%{token: token, distinct_id: user_id}, props)
    }

    Logger.debug("📤 Sending to Mixpanel")

    HTTPoison.post(
      "https://api.mixpanel.com/track?ip=1",
      "data=#{Base.encode64(Jason.encode!(payload))}",
      [{"Content-Type", "application/x-www-form-urlencoded"}]
    )
  end
end
