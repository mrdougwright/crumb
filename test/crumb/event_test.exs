defmodule Crumb.EventsTest do
  use Crumb.DataCase, async: true

  alias Crumb.Events
  alias Crumb.Events.Event

  describe "validate/1" do
    test "valid input returns {:ok, clean_params}" do
      params = %{
        "event" => "user_signup",
        "userId" => "abc123",
        "properties" => %{}
      }

      assert {:ok, clean_params} = Events.validate(params)
      assert clean_params.event == "user_signup"
      assert clean_params.user_id == "abc123"
      assert is_map(clean_params.properties)
      assert Map.has_key?(clean_params, :inserted_at)
    end

    test "missing required fields returns {:error, changeset}" do
      params = %{
        "properties" => %{}
      }

      assert {:error, changeset} = Events.validate(params)
      assert changeset.valid? == false
      assert ["can't be blank"] = errors_on(changeset).event
      assert ["can't be blank"] = errors_on(changeset).user_id
    end
  end

  describe "insert/1" do
    test "inserts a valid event" do
      {:ok, params} =
        Events.validate(%{
          "event" => "test_insert",
          "userId" => "user-1",
          "properties" => %{}
        })

      assert {:ok, %Event{} = event} = Events.insert({:ok, params})
      assert event.event == "test_insert"
      assert event.user_id == "user-1"
      assert Crumb.Repo.get_by!(Event, id: event.id)
    end

    test "fails with invalid changeset" do
      changeset = Ecto.Changeset.change(%Event{}) |> Ecto.Changeset.validate_required([:event])
      assert {:error, _cs} = Events.insert({:error, changeset})
    end
  end

  describe "enqueue/1" do
    test "calls Crumb.Queue.enqueue/1 with event" do
      {:ok, params} =
        Events.validate(%{
          "event" => "to_enqueue",
          "userId" => "user-2",
          "properties" => %{}
        })

      {:ok, event} = Events.insert({:ok, params})

      assert {:ok, ^event} = Events.enqueue({:ok, event})
    end

    test "returns error tuple without calling enqueue" do
      changeset = Ecto.Changeset.change(%Event{}) |> Ecto.Changeset.validate_required([:event])
      assert {:error, _} = Events.enqueue({:error, changeset})
    end
  end
end
