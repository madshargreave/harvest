defmodule HaCore.Repo.EctoImpl.Migrations.CreateRecords do
  use Ecto.Migration

  def change do
    create table(:records, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :table_id, :binary_id, null: false
      add :query_id, :binary_id, null: false
      add :unique_id, :binary_id, null: false
      add :data, :map
      timestamps()
    end

    create unique_index(:records, [:table_id, :unique_id])
  end
end
