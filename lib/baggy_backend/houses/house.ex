defmodule BaggyBackend.Houses.House do
  use Ecto.Schema
  import Ecto.Changeset
  alias BaggyBackend.Houses.House.Validator

  schema "houses" do
    field :code, :string
    field :name, :string
    field :passcode, :string

    timestamps()
  end

  @doc false
  def changeset(house, attrs) do
    house
    |> cast(attrs, [:name, :code, :passcode])
    |> validate_required([:name, :code, :passcode])
    |> validate_length(:code, min: 4, max: 8)
    |> validate_length(:passcode, is: 6)
    |> Validator.validate_passcode_strength()
    |> unique_constraint(:code)
  end
end
