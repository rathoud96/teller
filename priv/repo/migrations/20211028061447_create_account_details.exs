defmodule Teller.Repo.Migrations.CreateAccountDetails do
  use Ecto.Migration

  def change do
    create table(:account_details, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :account_number, :string
      add :ach, :string, null: true
      add :wire, :string, null: true
      add :bacs, :string, null: true
      add :account_id, references(:accounts, type: :uuid, on_delete: :nothing)

      timestamps()
    end

    create index(:account_details, [:account_id])
  end
end
