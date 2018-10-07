defmodule ExdBackend.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, :string, null: false
      add :status, :string, null: false
      add :query, :map, null: false
      timestamps()
    end

  end
end
