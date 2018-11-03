defmodule HaCore.Repo.EctoImpl.Migrations.CreateQueries do
  use Ecto.Migration

  def change do
    create table(:queries, primary_key: false) do
      add :id, :binary, primary_key: true
      add :user_id, :binary, null: false
      add :destination_id, :binary, null: false
      add :status, :string, null: false
      add :name, :string, null: false
      add :steps, {:array, :map}, null: false
      add :deleted_at, :naive_datetime

      timestamps()
    end
  end
end
