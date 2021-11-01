defmodule TellerWeb.AccountView do
  use TellerWeb, :view

  alias TellerWeb.AccountView
  alias TellerWeb.Endpoint

  def render("index.json", %{accounts: accounts}) do
    render_many(accounts, AccountView, "account.json")
  end

  def render("show.json", %{account: account}) do
    render_one(account, AccountView, "account.json")
  end

  def render("account.json", %{account: account}) do
    %{
      id: account.id,
      name: account.name,
      type: account.type,
      subtype: account.subtype,
      currency: account.currency,
      enrollment_id: account.enrollment_id,
      institution: %{
        id: account.institutions.id,
        name: account.institutions.name
      },
      links: %{
        details: Endpoint.url() <> "/accounts/#{account.id}/details",
        self: Endpoint.url() <> "/accounts/#{account.id}",
        balances: Endpoint.url() <> "/accounts/#{account.id}/balance",
        transactions: Endpoint.url() <> "/accounts/#{account.id}/transactions}"
      }
    }
  end

  def render("account_detail.json", %{account_detail: account_detail}) do
    %{
      account_id: account_detail.account_id,
      account_number: account_detail.account_number,
      routing_numbers: %{
        ach: account_detail.ach
      },
      links: %{
        self:
          Endpoint.url() <> "/accounts/#{account_detail.account_id}/details/#{account_detail.id}",
        account: Endpoint.url() <> "/accounts/#{account_detail.account_id}"
      }
    }
  end

  def render("account_balance.json", %{account_balance: account_balance}) do
    %{
      account_id: account_balance.account_id,
      ledger: account_balance.ledger,
      available: account_balance.available,
      links: %{
        self:
          Endpoint.url() <>
            "/accounts/#{account_balance.account_id}/balance/#{account_balance.id}",
        account: Endpoint.url() <> "/accounts/#{account_balance.account_id}"
      }
    }
  end

  def render("enrollment.json", %{token: token}) do
    %{
      api_key: token
    }
  end
end
