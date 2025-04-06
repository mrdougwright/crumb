defmodule Crumb.Queue do
  use GenServer
  require Logger

  @destinations [
    Crumb.Destination.Webhook
  ]

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
    Enum.each(@destinations, fn mod ->
      with true <- mod.enabled?() do
        case mod.send_event(event) do
          :ok -> :ok
          {:error, reason} -> Logger.warning("❌ #{inspect(mod)} failed: #{inspect(reason)}")
        end
      end
    end)
  end
end
