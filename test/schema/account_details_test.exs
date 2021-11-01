defmodule Teller.Schema.AccountDetailsTest do
  use Teller.DataCase, async: true

  alias Teller.Repo
  alias Teller.Schema.{AccountDetail, Enrollment, Institution}

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
    @valid_attrs %{account_id: "", account_number: "1234567890", ach: "123456789"}

    test "failure" do
      changeset = AccountDetail.changeset(%AccountDetail{}, @invalid_attrs)

      refute changeset.valid?
    end

    test "success" do
      account = create_account()
      attrs = %{@valid_attrs | account_id: account.id}
      changeset = AccountDetail.changeset(%AccountDetail{}, attrs)

      assert changeset.valid?
    end
  end
end
