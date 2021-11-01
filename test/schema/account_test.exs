defmodule Teller.Schema.AccountTest do
  use Teller.DataCase, async: true

  alias Teller.Repo
  alias Teller.Schema.{Account, Enrollment, Institution}

  describe "Insert data" do
    def create_enrollment do
      %Enrollment{}
      |> Enrollment.changeset(%{
        name: "David Anderson",
        username: "david101",
        password: "qwerty1234"
      })
      |> Repo.insert!()
    end

    def create_institution do
      %Institution{} |> Institution.changeset(%{name: "Royal Bank"}) |> Repo.insert!()
    end

    @invalid_attrs %{}
    @valid_attrs %{
      name: "Test account1",
      type: "depository",
      subtype: "checking",
      currency: "USD",
      last_four: "1234",
      enrollment_id: "",
      institution_id: ""
    }

    test "failure" do
      changeset = Account.changeset(%Account{}, @invalid_attrs)

      refute changeset.valid?
    end

    test "success" do
      enrollment = create_enrollment()
      institution = create_institution()
      attrs = %{@valid_attrs | enrollment_id: enrollment.id, institution_id: institution.id}
      changeset = Account.changeset(%Account{}, attrs)

      assert changeset.valid?
    end
  end
end
