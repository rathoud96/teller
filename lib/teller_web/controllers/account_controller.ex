defmodule TellerWeb.AccountController do
  use TellerWeb, :controller

  alias Teller.Accounts
  alias Teller.Schema.Enrollment

  def create(conn, params) do
    with {:ok, account} <- Accounts.create(params) do
      conn
      |> put_status(:created)
      |> render("account.json", account: account)
    end
  end

  def show(conn, params) do
    account = Accounts.get_account!(params["id"])

    conn
    |> put_status(:ok)
    |> render("account.json", account: account)
  end

  def account_details(conn, params) do
    account_detail = Accounts.account_details!(params["id"])

    conn
    |> put_status(:ok)
    |> render("account_detail.json", account_detail: account_detail)
  end

  def account_balance(conn, params) do
    account_balance = Accounts.account_balance!(params["id"])

    conn
    |> put_status(:ok)
    |> render("account_balance.json", account_balance: account_balance)
  end

  def create_account_details(conn, params) do
    params = Map.put(params, "account_id", params["id"])

    with {:ok, account_detail} <- Teller.AccountDetails.create(params) do
      conn
      |> put_status(:created)
      |> render("account_detail.json", account_detail: account_detail)
    end
  end

  def create_account_balance(conn, params) do
    params = Map.put(params, "account_id", params["id"])

    with {:ok, account_balance} <- Teller.AccountBalance.create(params) do
      conn
      |> put_status(:created)
      |> render("account_balance.json", account_balance: account_balance)
    end
  end

  def enroll(conn, params) do
    token =
      %Enrollment{}
      |> Enrollment.changeset(params)
      |> Teller.Repo.insert!()
      |> Enrollment.generate_api_key()

    conn
    |> put_status(:created)
    |> render("enrollment.json", token: token)
  end
end
