defmodule Teller.Transactions do
  import Ecto.Query
  alias Teller.Schema.Transaction
  alias Teller.Repo

  def create(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  def get_transaction!(id), do: Repo.get!(Transaction, id) |> Repo.preload(:counter_party)

  def get_transactions_by_account(account_id) do
    Repo.all(from t in Transaction, preload: [:counter_party], where: t.account_id == ^account_id)
  end
end
