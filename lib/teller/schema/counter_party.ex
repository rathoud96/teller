defmodule Teller.Schema.CounterParty do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.UUID

  @primary_key {:id, UUID, autogenerate: true}
  schema "counter_party" do
    field :name, :string
    field :type, :string

    belongs_to :transactions, Teller.Schema.Transaction, foreign_key: :transaction_id, type: UUID

    timestamps()
  end

  @fields [:type, :name, :transaction_id]

  @doc false
  def changeset(counter_party, attrs) do
    counter_party
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
