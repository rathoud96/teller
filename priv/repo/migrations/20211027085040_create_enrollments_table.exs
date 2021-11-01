defmodule Teller.Repo.Migrations.CreateEnrollmentsTable do
  use Ecto.Migration

  def change do
    create table(:enrollments, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :pass_hash, :string
      add :username, :string
      add :api_key, :string, null: true

      timestamps()
    end

    create index(:enrollments, [:id])
    create unique_index(:enrollments, [:username])
  end
end
