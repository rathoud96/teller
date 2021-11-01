defmodule TellerWeb.Controller.AccountsControllerTest do
  use Plug.Test
  use TellerWeb.ConnCase

  alias Teller.Repo
  alias Teller.Schema.{Enrollment, Institution}
  alias Teller.{AccountBalance, AccountDetails}

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
      conn = get(conn, Routes.account_path(conn, :show, Ecto.UUID.generate()))
      assert json_response(conn, 401)
    end

    test "/:id", %{conn: conn} do
      account = create_account()
      username = account.enrollments.username
      api_key = Teller.Encryption.encrypt(username)

      conn =
        build_conn()
        |> put_req_header("authorization", "Basic " <> Base.encode64("test_#{api_key}:"))
        |> get(Routes.account_path(conn, :show, account.id))

      assert json_response(conn, 200)
    end

    test "/:id/details", %{conn: conn} do
      account = create_account()
      username = account.enrollments.username
      api_key = Teller.Encryption.encrypt(username)

      AccountDetails.create(%{
        account_id: account.id,
        account_number: "1234567890",
        ach: "123456789"
      })

      response =
        build_conn()
        |> put_req_header("authorization", "Basic " <> Base.encode64("test_#{api_key}:"))
        |> get(Routes.account_path(conn, :account_details, account.id))
        |> json_response(200)

      assert response
    end

    test "/:id/balance", %{conn: conn} do
      account = create_account()
      username = account.enrollments.username
      api_key = Teller.Encryption.encrypt(username)

      AccountBalance.create(%{account_id: account.id, ledger: "76708.33", available: "76517.39"})

      response =
        build_conn()
        |> put_req_header("authorization", "Basic " <> Base.encode64("test_#{api_key}:"))
        |> get(Routes.account_path(conn, :account_balance, account.id))
        |> json_response(200)

      assert response
    end
  end
end
