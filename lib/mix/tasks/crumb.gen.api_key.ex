defmodule Mix.Tasks.Crumb.Gen.ApiKey do
  use Mix.Task
  alias Crumb.Repo
  alias Crumb.ApiKey

  @shortdoc "Generates a new API key for a project"

  def run([project]) do
    Mix.Task.run("app.start")

    token = generate_token()

    %ApiKey{}
    |> ApiKey.changeset(%{project: project, token: token, active: true})
    |> Repo.insert!()

    Mix.shell().info("✅ API key created for project '#{project}':")
    Mix.shell().info(token)
  end

  def run(_) do
    Mix.shell().error("Usage: mix crumb.gen.api_key PROJECT_NAME")
  end

  defp generate_token do
    :crypto.strong_rand_bytes(32)
    |> Base.url_encode64(padding: false)
  end
end
