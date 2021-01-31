defmodule BaggyBackend.Houses.House do
  @moduledoc """
  The house schema.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias BaggyBackend.{Houses.House.Validator, Products}

  import Ecto.Query, warn: false

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

  def member?(house, user, require_is_owner) do
    query =
      from hu in BaggyBackend.Houses.HousesUsers,
        where: hu.house_id == ^house.id and hu.user_uuid == ^user.uuid

    assoc = BaggyBackend.Repo.one(query)

    assoc && (!require_is_owner || (require_is_owner && assoc.is_owner))
  end
end
