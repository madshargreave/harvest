defmodule HaCore.Repo.EctoImpl.Migrations.CreateRecords do
  use Ecto.Migration

  def change do
    create table(:records, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :table_id, :uuid, null: false
      add :job_id, :uuid, null: false
      add :unique_id, :uuid, null: false
      add :data, :map
      timestamps()
    end

    create unique_index(:records, [:table_id, :unique_id])
  end
end
