defmodule Teller.Schema.TransactionTest do
  use Teller.DataCase, async: true

  alias Teller.Repo
  alias Teller.Schema.{Enrollment, Institution, Transaction}

  describe "Insert data" do
    def create_account do
      enrollment =
        %Enrollment{}
        |> Enrollment.changeset(%{
          name: "David Anderson",
          username: "david101",
          password: "qwerty1234"
        })
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

      account
    end

    @invalid_attrs %{}
    @valid_attrs %{
      account_id: "",
      amount: "200",
      description: "Resonance Education",
      date: DateTime.utc_now(),
      category: "education",
      processing_status: "complete",
      running_balance: "1800",
      status: "pending",
      type: "wire"
    }

    test "failure" do
      changeset = Transaction.changeset(%Transaction{}, @invalid_attrs)

      refute changeset.valid?
    end

    test "success" do
      account = create_account()
      attrs = %{@valid_attrs | account_id: account.id}
      changeset = Transaction.changeset(%Transaction{}, attrs)

      assert changeset.valid?
    end
  end
end
