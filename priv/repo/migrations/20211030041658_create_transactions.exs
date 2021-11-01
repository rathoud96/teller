defmodule Teller.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :amount, :string
      add :date, :utc_datetime_usec
      add :description, :string
      add :category, :string
      add :status, :string
      add :running_balance, :string, null: true
      add :type, :string
      add :processing_status, :string
      add :account_id, references(:accounts, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:transactions, [:account_id])
  end
end
