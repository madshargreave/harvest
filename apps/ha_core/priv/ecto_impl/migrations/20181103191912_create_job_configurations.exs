defmodule HaCore.Repo.EctoImpl.Migrations.CreateJobConfigurations do
  use Ecto.Migration

  def change do
    create table(:job_configurations, primary_key: false) do
      add :job_id, references(:jobs, type: :uuid), primary_key: true
      add :query_params, :map
      add :query, :text, null: false
      add :create_disposition, :string, null: false
      add :write_disposition, :string, null: false
      add :priority, :string, null: false
      add :use_source_cache, :boolean, default: false, null: false
      add :max_bad_records, :integer
      add :dry_run, :boolean, default: false, null: false
      add :destination_id, references(:tables, type: :uuid), null: false
    end
  end
end
