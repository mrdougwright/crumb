defmodule Crumb.Destination.Mixpanel do
  @behaviour Crumb.Destination
  require Logger

  def enabled?, do: System.get_env("MIXPANEL_TOKEN") != nil

  def transform(%{event: event, properties: props, user_id: user_id}) do
    token = System.get_env("MIXPANEL_TOKEN")

    %{
      event: event,
      properties: Map.merge(%{token: token, distinct_id: user_id}, props)
    }
  end

  def send_event(event) do
    Logger.debug("📤 Sending to Mixpanel")

    HTTPoison.post(
      "https://api.mixpanel.com/track?ip=1",
      "data=#{Base.encode64(Jason.encode!(event))}",
      [{"Content-Type", "application/x-www-form-urlencoded"}]
    )
  end
end
