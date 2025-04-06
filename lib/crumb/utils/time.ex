defmodule Crumb.Utils.Time do
  @doc """
  This is meant to be forgiving.
  Try to parse the string, otherwise return the datetime right now
  """
  def parse_str(ts) when is_binary(ts) do
    cond do
      # Full ISO with Z (works with DateTime)
      match?({:ok, _, _}, DateTime.from_iso8601(ts)) ->
        {:ok, dt, _} = DateTime.from_iso8601(ts)
        dt

      # Naive datetime with time
      match?({:ok, _}, NaiveDateTime.from_iso8601(ts)) ->
        {:ok, naive} = NaiveDateTime.from_iso8601(ts)
        DateTime.from_naive!(naive, "Etc/UTC")

      # Date only (like "2025-04-10")
      match?({:ok, _}, Date.from_iso8601(ts)) ->
        {:ok, date} = Date.from_iso8601(ts)

        date
        |> DateTime.new!(~T[00:00:00], "Etc/UTC")

      true ->
        DateTime.utc_now()
    end
  end

  def parse_str(_timestamp), do: DateTime.utc_now()
end
