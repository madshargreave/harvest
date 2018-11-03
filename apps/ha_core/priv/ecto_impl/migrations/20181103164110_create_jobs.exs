defmodule HaCore.Repo.EctoImpl.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :status, :string, null: false
      add :params, :map
      add :steps, {:array, :map}, default: [], null: false
      add :canceled_at, :naive_datetime
      add :create_disposition, :string, null: false
      add :write_disposition, :string, null: false
      add :priority, :string, null: false
      add :use_source_cache, :boolean, default: false, null: false
      add :max_bad_records, :integer
      add :dry_run, :boolean, default: false, null: false
      add :destination_id, references(:tables, type: :uuid), null: false
      timestamps()
    end
  end
end
