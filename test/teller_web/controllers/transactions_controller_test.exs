defmodule TellerWeb.Controller.TransactionsControllerTest do
  use Plug.Test
  use TellerWeb.ConnCase

  alias Teller.Repo
  alias Teller.Schema.{CounterParty, Enrollment, Institution}
  alias Teller.Transactions

  describe "GET /account" do
    def create_account do
      enrollment =
        %Enrollment{}
        |> Enrollment.changeset(%{name: "Test", username: "kakashi96", password: "qwerty1234"})
        |> Repo.insert!()

      institution =
        %Institution{} |> Institution.changeset(%{name: "Royal Bank"}) |> Repo.insert!()

      params = %{
        name: "Test account1",
        type: "depository",
        subtype: "checking",
        currency: "USD",
        last_four: "1234",
        enrollment_id: enrollment.id,
        institution_id: institution.id
      }

      {:ok, account} = Teller.Accounts.create(params)

      account |> Repo.preload(:enrollments)
    end

    test "401 for unautenticated route", %{conn: conn} do
      conn = get(conn, Routes.transaction_path(conn, :show, Ecto.UUID.generate()))
      assert json_response(conn, 401)
    end

    test "/:id", %{conn: conn} do
      account = create_account()
      username = account.enrollments.username
      api_key = Teller.Encryption.encrypt(username)

      {:ok, txn1} =
        Transactions.create(%{
          account_id: account.id,
          amount: "500",
          description: "ATM Withdrawal",
          date: DateTime.utc_now(),
          category: "services",
          processing_status: "complete",
          running_balance: "2000",
          status: "pending",
          type: "atm"
        })

      %CounterParty{}
      |> CounterParty.changeset(%{
        name: "CARDTRONICS",
        type: "organization",
        transaction_id: txn1.id
      })
      |> Repo.insert!()

      {:ok, txn2} =
        Transactions.create(%{
          account_id: account.id,
          amount: "200",
          description: "Resonance Education",
          date: DateTime.utc_now(),
          category: "education",
          processing_status: "complete",
          running_balance: "1800",
          status: "pending",
          type: "wire"
        })

      %CounterParty{}
      |> CounterParty.changeset(%{
        name: "Resonance Education",
        type: "organization",
        transaction_id: txn2.id
      })
      |> Repo.insert!()

      response =
        build_conn()
        |> put_req_header("authorization", "Basic " <> Base.encode64("test_#{api_key}:"))
        |> get(Routes.transaction_path(conn, :show, account.id))
        |> json_response(200)

      assert response
    end

    test "/:id/transactions/:transaction_id", %{conn: conn} do
      account = create_account()
      username = account.enrollments.username
      api_key = Teller.Encryption.encrypt(username)

      {:ok, transaction} =
        Transactions.create(%{
          account_id: account.id,
          amount: "200",
          description: "Resonance Education",
          date: DateTime.utc_now(),
          category: "education",
          processing_status: "complete",
          running_balance: "1800",
          status: "pending",
          type: "wire"
        })

      %CounterParty{}
      |> CounterParty.changeset(%{
        name: "Resonance Education",
        type: "organization",
        transaction_id: transaction.id
      })
      |> Repo.insert!()

      response =
        build_conn()
        |> put_req_header("authorization", "Basic " <> Base.encode64("test_#{api_key}:"))
        |> get(Routes.transaction_path(conn, :transaction, account.id, transaction.id))
        |> json_response(200)

      assert response
    end
  end
end
