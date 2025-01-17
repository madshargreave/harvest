defmodule HaCore.Repo.EctoImpl.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs, primary_key: false) do
      add :destination_id, references(:tables, type: :uuid)
      add :id, :uuid, primary_key: true
      add :status, :string, null: false
      add :canceled_at, :naive_datetime
      timestamps()
    end
  end
end
