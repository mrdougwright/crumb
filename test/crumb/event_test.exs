defmodule Crumb.EventsTest do
  use Crumb.DataCase, async: true

  alias Crumb.Events
  alias Crumb.Events.Event
  alias Crumb.Validator

  describe "insert/1" do
    test "inserts a valid event" do
      {:ok, params} =
        Validator.validate(%{
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
        Validator.validate(%{
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
