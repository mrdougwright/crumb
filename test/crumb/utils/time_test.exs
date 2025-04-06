defmodule Crumb.Utils.TimeTest do
  use Crumb.DataCase, async: true
  alias Crumb.Utils.Time

  describe "parse_str/1" do
    setup do
      %{now: DateTime.utc_now()}
    end

    test "parses datetime: 2025-04-06 15:55:58.110279Z from string", %{now: now} do
      assert now
             |> DateTime.to_string()
             |> Time.parse_str() == now
    end

    test "parses naive datetime: 2025-04-06 15:55:58 from string", %{now: now} do
      assert now
             |> NaiveDateTime.to_string()
             |> Time.parse_str() == now
    end

    test "parses date: 2025-04-06 from string" do
      now = "2025-04-10"
      assert Time.parse_str(now) == ~U[2025-04-10 00:00:00Z]
    end
  end
end
