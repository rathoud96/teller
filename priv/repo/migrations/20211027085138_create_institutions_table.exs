defmodule Teller.Repo.Migrations.CreateInstitutionsTable do
  use Ecto.Migration

  def change do
    create table(:institutions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false

      timestamps()
    end

    create index(:institutions, [:id])
  end
end
