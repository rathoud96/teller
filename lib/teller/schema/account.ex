defmodule Teller.Schema.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "accounts" do
    field :currency, :string
    field :name, :string
    field :subtype, :string
    field :type, :string
    field :last_four, :string

    belongs_to :institutions, Teller.Schema.Institution,
      foreign_key: :institution_id,
      type: Ecto.UUID

    belongs_to :enrollments, Teller.Schema.Enrollment,
      foreign_key: :enrollment_id,
      type: Ecto.UUID

    has_many :transactions, Teller.Schema.Transaction
    has_one :account_details, Teller.Schema.AccountDetail
    has_one :account_balance, Teller.Schema.AccountBalance

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [
      :name,
      :type,
      :subtype,
      :currency,
      :last_four,
      :institution_id,
      :enrollment_id
    ])
    |> validate_required([
      :name,
      :type,
      :subtype,
      :currency,
      :last_four,
      :enrollment_id,
      :institution_id
    ])
  end
end
