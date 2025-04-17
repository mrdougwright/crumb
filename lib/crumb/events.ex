defmodule Crumb.Events do
  @moduledoc """
  Context for Event logic
  """

  alias Crumb.Events.Event
  alias Crumb.Repo

  def insert({:ok, clean_params}) do
    changeset = Event.changeset(%Event{}, clean_params)

    case Repo.insert(changeset) do
      {:ok, event} -> {:ok, event}
      {:error, cs} -> {:error, cs}
    end
  end

  def insert({:error, _} = err), do: err

  def enqueue({:ok, data}, :event) do
    Crumb.Queue.enqueue(data)
    {:ok, data}
  end

  def enqueue({:ok, data}, :identify) do
    Crumb.Queue.identify(data)
    {:ok, data}
  end

  def enqueue({:error, _} = err), do: err
end
