defmodule Crumb.ApiKeyFixtures do
  alias Crumb.Repo
  alias Crumb.ApiKey

  def api_key_fixture(attrs \\ %{}) do
    defaults = %{
      token: "test-token-#{System.unique_integer([:positive])}",
      project: "test-project",
      active: true
    }

    merged = Map.merge(defaults, attrs)

    %ApiKey{}
    |> ApiKey.changeset(merged)
    |> Repo.insert!()
  end
end
