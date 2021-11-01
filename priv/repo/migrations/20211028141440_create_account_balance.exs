defmodule Teller.Repo.Migrations.CreateAccountBalance do
  use Ecto.Migration

  def change do
    create table(:account_balance, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :available, :string
      add :ledger, :string
      add :account_id, references(:accounts, type: :uuid, on_delete: :nothing)

      timestamps()
    end

    create index(:account_balance, [:account_id])
  end
end
