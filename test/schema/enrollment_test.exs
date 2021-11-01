defmodule Teller.Schema.EnrollmentTest do
  use Teller.DataCase, async: true

  alias Teller.Schema.Enrollment

  describe "Insert data" do
    @invalid_attrs %{}
    @valid_attrs %{name: "David Anderson", username: "david101", password: "qwerty1234"}

    test "failure" do
      changeset = Enrollment.changeset(%Enrollment{}, @invalid_attrs)

      refute changeset.valid?
    end

    test "success" do
      changeset = Enrollment.changeset(%Enrollment{}, @valid_attrs)

      assert changeset.valid?
    end

    test "password with less than 8 character" do
      attrs = %{@valid_attrs | password: "qwer"}
      changeset = Enrollment.changeset(%Enrollment{}, attrs)

      assert %{password: ["should be at least 8 character(s)"]} = errors_on(changeset)
    end

    test "duplicate username" do
      changeset = Enrollment.changeset(%Enrollment{}, @valid_attrs)
      Teller.Repo.insert!(changeset)

      new_changeset = Enrollment.changeset(%Enrollment{}, @valid_attrs)

      assert {:error, changeset} = Teller.Repo.insert(new_changeset)
      assert %{username: ["has already been taken"]} = errors_on(changeset)
    end
  end
end
