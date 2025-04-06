defmodule Crumb.Destination do
  @moduledoc """
  enabled?/0 → should Crumb call it?
  send_event/1 → do the actual sending
  """
  @callback enabled?() :: boolean()
  @callback send_event(map()) :: :ok | {:error, term()}
end
