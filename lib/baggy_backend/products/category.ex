defmodule BaggyBackend.Products.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "product_categories" do
    field :color, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :color])
    |> validate_required([:name, :color])
    |> validate_format(:color, ~r/^#([a-fA-F0-9]{6}|[a-fA-F0-9]{3})$/)
    |> unique_constraint(:name)
  end
end
