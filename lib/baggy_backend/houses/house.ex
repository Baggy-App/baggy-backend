defmodule BaggyBackend.Houses.House do
  @moduledoc """
  The house schema.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias BaggyBackend.{Houses.House.Validator, Products}

  schema "houses" do
    field :code, :string
    field :name, :string
    field :passcode, :string

    has_many :product_lists, Products.ProductList

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

  def correct_passcode?(house, passcode) do
    if house, do: house.passcode == passcode, else: raise(ArgumentError, "Empty house.")
  end

  def is_owner?(_house, _user) do
    true
  end
end
