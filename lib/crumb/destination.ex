defmodule Crumb.Destination do
  @moduledoc """
  Behaviour for sending events to destinations.

  enabled?/0 - Check if destination is enabled (user has set env key).
  transform/1 - Transform data if/where needed for destination.
  send_event/1 - Send event to destination (response ignored).

  Optional Callbacks:
  identify/1 - Identify user traits.
  """

  @callback enabled?() :: boolean()
  @callback transform(map()) :: map()
  @callback send_event(map()) :: {:ok, HTTPoison.Response.t()} | {:error, term()}

  @optional_callbacks identify: 1
  @callback identify(map()) :: {:ok, HTTPoison.Response.t()} | {:error, term()}
end
