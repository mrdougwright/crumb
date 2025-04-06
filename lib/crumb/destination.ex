defmodule Crumb.Destination do
  @moduledoc """
  Check if destination is enabled (user has set env key).
  Transform data if/where needed for destination.
  Send event to destination (response ignored).
  """

  @callback enabled?() :: boolean()
  @callback transform(map()) :: map()
  @callback send_event(map()) :: {:ok, HTTPoison.Response.t()} | {:error, term()}
end
