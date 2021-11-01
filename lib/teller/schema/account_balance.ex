defmodule Teller.Schema.AccountBalance do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "account_balance" do
    field :available, :string
    field :ledger, :string

    belongs_to :accounts, Teller.Account, foreign_key: :account_id, type: Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(account_balance, attrs) do
    account_balance
    |> cast(attrs, [:account_id, :available, :ledger, :account_id])
    |> validate_required([:account_id, :available, :ledger, :account_id])
  end
end
