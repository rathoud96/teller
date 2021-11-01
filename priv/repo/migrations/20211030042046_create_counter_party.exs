defmodule Teller.Repo.Migrations.CreateCounterParty do
  use Ecto.Migration

  def change do
    create table(:counter_party, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :type, :string
      add :transaction_id, references(:transactions, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:counter_party, [:transaction_id])
  end
end
