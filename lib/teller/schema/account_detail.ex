defmodule Teller.Schema.AccountDetail do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "account_details" do
    field :account_number, :string
    field :ach, :string
    field :bacs, :string
    field :wire, :string

    belongs_to :accounts, Teller.Schema.Account, foreign_key: :account_id, type: Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(account_detail, attrs) do
    account_detail
    |> cast(attrs, [:account_number, :ach, :wire, :bacs, :account_id])
    |> validate_required([:account_number, :account_id])
  end
end
