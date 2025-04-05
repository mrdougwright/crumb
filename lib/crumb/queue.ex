defmodule Crumb.Queue do
  use GenServer

  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def enqueue(event) do
    GenServer.cast(__MODULE__, {:enqueue, event})
  end

  @impl true
  def init(_state) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:enqueue, event}, state) do
    Logger.debug("📦 Received event: #{inspect(event.event)}")

    Task.start(fn ->
      forward_event(event)
    end)

    {:noreply, state}
  end

  defp forward_event(event) do
    url = System.get_env("FORWARD_WEBHOOK_URL")

    if url do
      body = %{
        event: event.event,
        properties: event.properties,
        user_id: event.user_id,
        sent_at: DateTime.utc_now()
      }

      headers = [{"Content-Type", "application/json"}]

      Logger.debug("🚀 Forwarding to #{url}")
      HTTPoison.post(url, Jason.encode!(body), headers)
    else
      Logger.warning("⚠️ No FORWARD_WEBHOOK_URL configured.")
    end
  end
end
