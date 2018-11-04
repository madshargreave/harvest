defmodule HaCore.Repo.EctoImpl.Migrations.CreateQueries do
  use Ecto.Migration

  def change do
    create table(:queries, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, :uuid, null: false
      add :name, :string, null: false
      add :steps, {:array, :map}, null: false
      add :params, :map
      add :deleted_at, :naive_datetime

      timestamps()
    end
  end
end
