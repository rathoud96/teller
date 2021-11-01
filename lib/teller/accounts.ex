defmodule Teller.Accounts do
  @moduledoc """
  Wrapper around Account Schema for DB operations
  """

  alias Teller.Schema.{Account, AccountDetail, AccountBalance}
  alias Teller.Repo

  def create(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  def get_account!(id), do: Repo.get!(Account, id) |> Repo.preload(:institutions)

  def list_accounts, do: Repo.all(Account) |> Repo.preload(:institutions)

  def account_details!(id), do: Repo.get_by(AccountDetail, account_id: id)

  def account_balance!(id), do: Repo.get_by!(AccountBalance, account_id: id)
end
