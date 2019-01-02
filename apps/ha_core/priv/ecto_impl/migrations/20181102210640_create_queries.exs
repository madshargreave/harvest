defmodule HaCore.Repo.EctoImpl.Migrations.CreateQueries do
  use Ecto.Migration

  def change do
    create table(:query_schedules, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :active, :boolean, null: false
      add :schedule, :string, null: false
      timestamps()
    end

    create table(:queries, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :schedule_id, references(:query_schedules, type: :uuid)
      add :user_id, :uuid, null: false
      add :status, :string, null: false
      add :name, :string, null: false
      add :query, :text, null: false
      add :params, :map
      add :deleted_at, :naive_datetime
      add :saved, :boolean
      add :live, :boolean

      timestamps()
    end
  end
end
