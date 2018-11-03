defmodule HaCore.Repo.EctoImpl.Migrations.CreateTables do
  use Ecto.Migration

  def change do
    create table(:tables, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :size, :integer, default: 0, null: false
      add :primary_key, :string, null: false
      timestamps()
    end
  end
end
