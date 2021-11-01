defmodule Teller.AccountDetails do
  alias Teller.Schema.AccountDetail
  alias Teller.Repo

  def create(attrs \\ %{}) do
    %AccountDetail{}
    |> AccountDetail.changeset(attrs)
    |> Repo.insert()
  end

  def get_account_details!(id), do: Repo.get!(AccountDetail, id)

  def list_account_details, do: Repo.all(AccountDetail)
end
