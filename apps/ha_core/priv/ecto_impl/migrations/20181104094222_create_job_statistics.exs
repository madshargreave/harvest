defmodule HaCore.Repo.EctoImpl.Migrations.CreateJobStatistics do
  use Ecto.Migration

  def change do
    create table(:job_statistics, primary_key: false) do
      add :job_id, references(:jobs, type: :uuid), primary_key: true
      add :started_at, :naive_datetime, null: false
      add :ended_at, :naive_datetime, null: false
    end
  end
end
