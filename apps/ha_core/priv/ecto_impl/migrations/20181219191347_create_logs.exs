defmodule HaCore.Repo.EctoImpl.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs, primary_key: false) do
      add :job_id, references(:jobs, type: :uuid), primary_key: true
      add :type, :string, null: false
      add :data, :map, null: false
      add :timestamp, :naive_datetime, primary_key: true
    end
  end
end
