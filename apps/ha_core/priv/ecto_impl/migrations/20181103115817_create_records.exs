defmodule HaCore.Repo.EctoImpl.Migrations.CreateRecords do
  use Ecto.Migration

  def change do
    create table(:records, primary_key: false) do
      add :key, :string, primary_key: true
      add :table, :string, null: false, primary_key: true
      add :value, :map
    end
  end
end
