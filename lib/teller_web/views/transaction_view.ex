defmodule TellerWeb.TransactionView do
  use TellerWeb, :view

  alias TellerWeb.TransactionView

  alias TellerWeb.Endpoint

  def render("index.json", %{transactions: transactions}) do
    render_many(transactions, TransactionView, "transaction.json")
  end

  def render("show.json", %{transaction: transaction}) do
    render_one(transaction, TransactionView, "transaction.json")
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{
      id: transaction.id,
      account_id: transaction.account_id,
      amount: transaction.amount,
      date: transaction.date,
      description: transaction.description,
      running_balance: transaction.running_balance,
      status: transaction.status,
      type: transaction.type,
      details: %{
        category: transaction.category,
        processing_status: transaction.processing_status,
        counter_party: %{
          name: transaction.counter_party.name,
          type: transaction.counter_party.type
        }
      },
      links: %{
        self:
          Endpoint.url() <> "/accounts/#{transaction.account_id}/transactions/#{transaction.id}",
        account: Endpoint.url() <> "/accounts/#{transaction.account_id}"
      }
    }
  end
end
