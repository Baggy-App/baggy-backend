defmodule BaggyBackend.Products.Product.Validator do
  @moduledoc """
    Validator for Product schema changeset.
  """

  import Ecto.Changeset

  def validate_price_limits(changeset) do
    {_, min_price} = fetch_field(changeset, :min_price)
    {_, max_price} = fetch_field(changeset, :max_price)

    if min_lower_than_max?(min_price, max_price) do
      changeset
    else
      message = "Minimum price must be lower or equal to maximum price."
      add_error(changeset, :min_price, message)
    end
  end

  defp min_lower_than_max?(_price_min, nil), do: true
  defp min_lower_than_max?(nil, _price_max), do: true
  defp min_lower_than_max?(min_price, max_price), do: min_price <= max_price
end
