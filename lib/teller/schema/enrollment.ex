defmodule Teller.Schema.Enrollment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "enrollments" do
    field :name, :string
    field :username, :string
    field :pass_hash, :string
    field :password, :string, virtual: true
    field :api_key, :string

    has_many :accounts, Teller.Schema.Account

    timestamps()
  end

  @doc false
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:name, :username, :password, :pass_hash, :api_key])
    |> validate_required([:name, :username, :password])
    |> validate_length(:password, min: 8)
    |> unique_constraint(:username)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :pass_hash, Bcrypt.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end

  def generate_api_key(enrollment), do: "test_" <> Teller.Encryption.encrypt(enrollment.username)
end
