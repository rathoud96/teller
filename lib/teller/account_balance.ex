defmodule Teller.AccountBalance do
  alias Teller.Schema.AccountBalance
  alias Teller.Repo

  def create(attrs \\ %{}) do
    %AccountBalance{}
    |> AccountBalance.changeset(attrs)
    |> Repo.insert()
  end

  def get_account!(id), do: Repo.get!(AccountBalance, id)

  def list_account_balance, do: Repo.all(AccountBalance)
end
