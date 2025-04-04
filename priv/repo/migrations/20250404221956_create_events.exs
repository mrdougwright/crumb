defmodule Crumb.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :event, :string
      add :user_id, :string
      add :properties, :map

      timestamps(type: :utc_datetime)
    end
  end
end
