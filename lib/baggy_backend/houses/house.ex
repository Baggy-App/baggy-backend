defmodule BaggyBackend.Houses.House do
  @moduledoc """
  The house schema.
  """
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
    |> Validator.validate_passcode()
    |> unique_constraint(:code)
  end


  def validate_passcode(house, passcode) do
    house.passcode == passcode
  end

end
