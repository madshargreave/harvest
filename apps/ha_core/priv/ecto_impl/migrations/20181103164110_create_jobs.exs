defmodule HaCore.Repo.EctoImpl.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :status, :string, null: false
      add :steps, {:array, :map}, default: [], null: false
      add :canceled_at, :naive_datetime
      add :query_id, references(:queries, type: :uuid), null: false
      timestamps()
    end
  end
end
