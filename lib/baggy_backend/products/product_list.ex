defmodule BaggyBackend.Products.ProductList do
  use Ecto.Schema
  import Ecto.Changeset
  @moduledoc """
  The product_list schema.
  """
  schema "product_lists" do
    field :name, :string

    belongs_to :house, BaggyBackend.Houses.House
    has_many :products, BaggyBackend.Products.Product

    timestamps()
  end

  @doc false
  def changeset(product_list, attrs) do
    product_list
    |> cast(attrs, [:name, :house_id])
    |> validate_required([:name, :house_id])
    |> foreign_key_constraint(:house_id)
  end
end
