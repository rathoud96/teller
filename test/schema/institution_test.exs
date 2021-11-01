defmodule Teller.Schema.InstitutionTest do
  use Teller.DataCase, async: true

  alias Teller.Schema.Institution

  describe "Insert data" do
    @invalid_attrs %{}
    @valid_attrs %{name: "Citi Bank"}

    test "failure" do
      changeset = Institution.changeset(%Institution{}, @invalid_attrs)

      refute changeset.valid?
    end

    test "success" do
      changeset = Institution.changeset(%Institution{}, @valid_attrs)

      assert changeset.valid?
    end
  end
end
