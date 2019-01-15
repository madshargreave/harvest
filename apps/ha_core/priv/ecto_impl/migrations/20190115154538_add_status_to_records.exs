defmodule HaCore.Repo.EctoImpl.Migrations.AddStatusToRecords do
  use Ecto.Migration

  def change do
    alter table(:records) do
      add :table_id, references(:tables, type: :binary_id), null: false
      add :status, :string, null: false
      add :ts, :naive_datetime, null: false
      add :previous, :map
    end
  end

end
