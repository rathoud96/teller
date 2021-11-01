defmodule Teller.Schema.Institution do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "institutions" do
    field :name, :string

    has_many :accounts, Teller.Schema.Account

    timestamps()
  end

  @doc false
  def changeset(institution, attrs) do
    institution
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
