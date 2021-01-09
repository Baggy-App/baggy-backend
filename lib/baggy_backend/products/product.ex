defmodule BaggyBackend.Products.Product do
  @moduledoc """
  Schema for products.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias BaggyBackend.Products.Product.Validator

  schema "products" do
    field :description, :string
    field :done, :boolean, default: false
    field :max_price, :integer
    field :min_price, :integer
    field :name, :string
    field :quantity, :integer

    belongs_to :product_list, BaggyBackend.Products.ProductList

    belongs_to :product_category, BaggyBackend.Products.Category

    belongs_to :user, BaggyBackend.Accounts.User,
      foreign_key: :user_uuid,
      references: :uuid,
      type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [
      :name,
      :description,
      :quantity,
      :min_price,
      :max_price,
      :done,
      :product_list_id,
      :product_category_id,
      :user_uuid
    ])
    |> validate_required([:name, :quantity, :done, :product_list_id, :product_category_id])
    |> validate_length(:name, min: 1)
    |> Validator.validate_price_limits()
    |> foreign_key_constraint(:product_list_id)
    |> foreign_key_constraint(:product_category_id)
  end
end
