defmodule HaCore.Repo.EctoImpl.Migrations.AddAstToJobConfigurations do
  use Ecto.Migration

  def change do
    alter table(:job_configurations) do
      add :ast, :map
    end
  end

end
