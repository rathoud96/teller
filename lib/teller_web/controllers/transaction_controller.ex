defmodule TellerWeb.TransactionController do
  use TellerWeb, :controller

  alias Teller.Transactions

  def create(conn, params) do
    with {:ok, transaction} <- Transactions.create(params) do
      conn
      |> put_status(:created)
      |> render("transaction.json", transaction: transaction)
    end
  end

  def show(conn, params) do
    transactions = Transactions.get_transactions_by_account(params["id"])

    conn
    |> put_status(:ok)
    |> render("index.json", transactions: transactions)
  end

  def transaction(conn, params) do
    transaction = Transactions.get_transaction!(params["transaction_id"])

    conn
    |> put_status(:ok)
    |> render("transaction.json", transaction: transaction)
  end
end
