defmodule HaCore.Repo.EctoImpl.Migrations.CreateDatasets do
  use Ecto.Migration

  def change do
    create table(:datasets, primary_key: false) do
      add :id, :binary, primary_key: true
      add :name, :string, null: false
      add :user_id, :string, null: false

      timestamps()
    end
  end
end
