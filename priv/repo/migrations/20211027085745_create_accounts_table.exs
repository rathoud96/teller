defmodule Teller.Repo.Migrations.CreateAccountsTable do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :type, :string, null: false
      add :subtype, :string, null: false
      add :currency, :string, null: false
      add :last_four, :string, null: false
      add :institution_id, references(:institutions, type: :uuid)
      add :enrollment_id, references(:enrollments, type: :uuid)

      timestamps()
    end

    create index(:accounts, [:id])
  end
end
