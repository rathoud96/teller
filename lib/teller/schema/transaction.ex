defmodule Teller.Schema.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.UUID

  @primary_key {:id, UUID, autogenerate: true}
  schema "transactions" do
    field :amount, :string
    field :category, :string
    field :date, :utc_datetime_usec
    field :description, :string
    field :running_balance, :string
    field :status, :string
    field :type, :string
    field :processing_status, :string

    belongs_to :accounts, Teller.Schema.Account, foreign_key: :account_id, type: UUID
    has_one :counter_party, Teller.Schema.CounterParty

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [
      :amount,
      :date,
      :description,
      :category,
      :status,
      :running_balance,
      :type,
      :account_id,
      :processing_status
    ])
    |> validate_required([
      :amount,
      :date,
      :description,
      :category,
      :status,
      :type,
      :account_id,
      :processing_status
    ])
  end
end
